unit scope_clock;

// #############################################################################
// ###                         VECTOR ENGINE                                 ###
// #############################################################################
// Vector Data (LV_INC = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
// C = Command, LSB in 15:12, MSB in 31:24
// Y = Y-Wert oder Kreisabschnitt-Ende,
// X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse
// Commands:
// 0  - Setze Startpunkt oder Kreismitte X/Y absolut
// 1  - Setze Startpunkt oder Kreismitte X/Y relativ
// 2  - Zeichne Linie nach X/Y absolut
// 3  - Zeichne Linie nach X/Y relativ, Beam Low
// 4  - Setze Kreisabschnitt (Winkel) nach X-Wert, 825 = Vollkreis
// 5  - Setze Kreis-Radius nach X-Wert und Auflösung nach Y-Wert (1..7), zeichne Kreis
// 6  - Setze Offset für nächste Objekte, X/Y
// 7  - Setze Rotations-Mittelpunkt für nächste Objekte, X/Y
// 8  - Setze Rotation für nächste Objekte um Offset-Nullpunkt, X = Winkel in 2 * pi * 128
// 9  - Setze Skalierung nach X/Y-Werten, $400 = 100%
// 10 - Pause, X-Wert * 5µs
// 11 - Dummy Cycle, NOP wenn X=0
// 12 - Stop, warte auf Reset
// 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
// 14 - Aufruf Subroutine an Adresse X
// 15 - Return aus Subroutine
// 16 - Setze Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Setze Deflection Timer XXXX XXXX XXXX 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Setze XY Punkt
// 19 - SKIP, JUMP Relativ +X

// VEC-Datei beginnt immer mit 7 Initialisierungsvektoren:
// 0 = Skip/NOP (Objekt-Startkennung) mit X=Anzahl und Y=Animationstyp,
// 1 = Beam,
// 2 = Scale XY,
// 3 = Offset XY,
// 4 = Rotation,
// 5 = Center XY,
// 6 = Speed


// Logo mit Inkscape als HPGL speichern und mit hpgl_to_pas.exe konvertieren,
// speichern als "logoX_vectors.txt", Array-Nummer einsetzen
// c_logo1_arr[] und c_logo2_arr[]

// Buttons (Bit-Nr.) ButtonPort_0:
// 0-Fire, 1=Rturn, 2=Coin, 3=Lturn, 4=Thrust, 5=Start, 6=Shield
// Buttons (Bit-Nr.) ButtonPort_1:
// 0-DEC, 1-INC, 2-Set H, M, S, Weekday, Day, Month, Year, DaysLeft, Run
// 3-END SetMode

interface

uses
 fpga_if, rtc_maxim, vectorengine_spi, files, parser, global_vars;


procedure InitScopeClock;
procedure HandleScopeClock;
Procedure CheckDamage;

implementation


const

c_sinusArr: Array[0..59] of Int8 = (
 0, 13, 26, 39, 52, 64, 75, 85, 94, 103, 110, 116, 121, 124,
 126, 127, 126, 124, 121, 116, 110, 103, 94, 85, 75, 64, 52,
 39, 26, 13, 0, -13, -26, -39, -52, -64, -75, -85, -94, -103,
 -110, -116, -121, -124, -126, -127, -126, -124, -121, -116,
 -110, -103, -94, -85, -75, -64, -52, -39, -26, -13
  );

// -128,xxx = MoveTo next vector (pen up) wie in simplex_font_32_95.txt
c_UfoArr: Array[0..33] of Int8 = (
  16, 20, // Anzahl Vektoren XY, Breite (Spacing) wie in simplex_font_32_95.txt
  -10, 0, -4,-4, 4,-4, 10,0, 4,4, 2,8, -2,8, -4,4, -10,0,
  -128,-128, -10,0,  10,0, -128,-128, -4,4, 4,4, -128,-128);

c_WeekdayArr: Array[0..7] of String[11] = (
  'SONNTAG', 'MONTAG', 'DIENSTAG',  'MITTWOCH',
  'DONNERSTAG', 'FREITAG', 'SAMSTAG', 'KEINTAG');

var
{$PDATA}

  LED[@PortB, 5]: Bit;
  SW1[@PinB, 4]: Bit;
  SW2[@PinB, 6]: Bit;
  // PB5=Nano-LED


{$IDATA}
  TickCount, AnimationTimer: Byte;
  ActiveCounter: Byte;
  ClockActive: Boolean;
  Tick10sema, AnimationSema: Boolean;
  RandomInt: Integer;

  Pendulum: t_pendulumobject;
  ClockFace, SecondsHand, MinutesHand, HoursHand: t_clockobject;
  RotatingText, Logo, DateDisplay, WeekdayDisplay: t_animobject;

  x_arrTicksOuter, y_arrTicksOuter: Array[0..59] of Int8; // Außenkreis

  CurrentDayCount, DestDayCount, DaysLeft: Integer;

  MsgStr: String[19];

// #############################################################################

procedure onSysTick;
// mod / div führt zu Störungen!
// alle Hundertstel Sekunden aufgerufen
begin
  Inc(TickCount);
  SysTickSema:= true;
  Inc(Sec100);
  if Sec100 >= 100 then
    Sec100:= 0;
  endif;
end;


procedure RTCtickHour;
begin
  HourSema:= true;
end;

procedure RTCtickMinute;
begin
  MinuteSema:= true;
end;

procedure RTCtickSecond;
begin
  SecondSema:= true;
end;

// #############################################################################

procedure CreateClockFace;
var tx, ty: Int8;
begin
  ClockFace.vecupd_start:= VE_NextVector;
  VE_UploadVals(ve_set_offs, 0, 0);
  for k:= 0 to 59 do
    tx:= x_arrTicksOuter[k];
    ty:= y_arrTicksOuter[k];
    if k mod 5 = 0 then
      VE_MoveTo_b(tx, ty);
      tx:= tx - (tx div 10);
      ty:= ty - (ty div 10);
      VE_DrawLineTo_b(tx, ty, VE_beamhi);
    else
      VE_DrawPointAt_b(tx, ty, VE_beammid);
    endif;
  endfor;
  VE_DrawCircleSegmentAt_b(0, 0, 10, 0, 360, VE_beammid);
  VE_DrawCircleSegmentAt_b(0, 0, 112, 0, 360, VE_beammid);
  VE_DrawCircleSegmentAt_b(0, 0, 90, 180 - 20, 180 + 20, VE_beammid);
  tx:= -10;
  ty:= 83;
  VE_DrawCharAt_b(tx, ty, '1', 50);
  tx:= -2;
  VE_DrawCharAt_b(tx, ty, '2', 50);
  tx:= -5;
  ty:= -93;
  VE_DrawCharAt_b(tx, ty, '6', 50);
  tx:= 85;
  ty:= -6;
  VE_DrawCharAt_b(tx, ty, '3', 50);
  tx:= -94;
  ty:= -6;
  VE_DrawCharAt_b(tx, ty, '9', 50);
  ClockFace.vecupd_end:= VE_NextVector;
  VE_SetBeamInt(VE_beamlow);
  VE_DrawStringAt_b(-30, 30, 'NOCH ' + IntToSTr(DaysLeft) + ' TAGE', 25);  // mögl. viele Vektoren
end;

procedure UpdateSecondsHand;
begin
  // SecondsHand.rotations:= mulDivInt(Integer(Sec100), 6, 100) - 6;
  SecondsHand.rotation:= 360 - Integer(Second) * 6;
  VE_UploadBegin(SecondsHand.vecupd_start);
  VE_SetRotationDeg(SecondsHand.rotation);  // 1 Vektor
end;

procedure CreateSecondsHand;
var tx, ty: Int8;
begin
  // Sekundenzeiger
  SecondsHand.vecupd_start:= VE_NextVector;
  UpdateSecondsHand; // trägt ve_set_rot_deg an Adresse +2 ein
  SecondsHand.vecupd_end:= VE_NextVector;
  VE_DrawCircleSegmentAt_b(0, -20, 4, 0, 360, VE_beammid);
  VE_MoveTo_b(0, -16);
  VE_DrawLineTo_b(0, 100, VE_beammid);
  VE_DrawPinPointAt_b(0, 100, VE_beammid);
  VE_DrawCircleSegmentAt_b(0, 0, 2, 0, 360, VE_beammid);
  VE_UploadVals(ve_set_rot_deg, 0, 0); // da Rotation upgedated wurde
end;

procedure UpdateMinutesHand;
begin
  // minute_degsteps:= mulDivInt(Integer(Sec100), 6, 100) - 6;
  MinutesHand.rotation:= 360 - Integer(Minute) * 6;
  VE_UploadBegin(MinutesHand.vecupd_start);
  VE_SetRotationDeg(MinutesHand.rotation);  // 1 Vektor
end;

procedure CreateMinutesHand;
begin
  MinutesHand.vecupd_start:= VE_NextVector;
  UpdateMinutesHand; // trägt ve_set_rot_deg an Adresse +2 ein
  // Minutenzeiger auf 12:00
  VE_MoveTo_b(0, 95);
  VE_DrawLineTo_b(0, 10, VE_beamlow);
  VE_MoveTo_b(0, 95);
  VE_DrawLineTo_b(-4, 65, VE_beammid);
  VE_DrawLineTo_b(-2, 10, VE_beammid); // Endposition
  VE_MoveTo_b(0, 95);
  VE_DrawLineTo_b(4, 65, VE_beammid);
  VE_DrawLineTo_b(2, 10, VE_beammid); // Endposition
  MinutesHand.vecupd_end:= VE_NextVector;
  VE_UploadVals(ve_set_rot_deg, 0, 0); // da Rotation upgedated wurde
end;

procedure UpdateHoursHand;
begin
  // minute_degsteps:= mulDivInt(Integer(Sec100), 6, 100) - 6;
  HoursHand.rotation:= 360 - Integer(Hour mod 12) * 30 - Integer(Minute) div 2;
  VE_UploadBegin(HoursHand.vecupd_start);
  VE_SetRotationDeg(HoursHand.rotation);  // 1 Vektor
end;

procedure CreateHoursHand;
begin
  HoursHand.vecupd_start:= VE_NextVector;
  UpdateHoursHand; // trägt ve_set_rot_deg an Adresse +2 ein
  HoursHand.vecupd_end:= VE_NextVector;
  // Stundenzeiger auf 12:00
  VE_MoveTo_b(0, 65);
  VE_DrawLineTo_b(0, 10, VE_beamlow);
  VE_MoveTo_b(0, 65);
  VE_DrawLineTo_b(-5, 45, VE_beammid);
  VE_DrawLineTo_b(-3, 10, VE_beammid); // Endposition
  VE_MoveTo_b(0, 65);
  VE_DrawLineTo_b(5, 45, VE_beammid);
  VE_DrawLineTo_b(3, 10, VE_beammid); // Endposition
  VE_UploadVals(ve_set_rot_deg, 0, 0); // da Rotation upgedated wurde
end;

procedure UpdatePendulum;
begin
  VE_UploadBegin(Pendulum.vecupd_start);
  VE_UploadVals(ve_set_rot_deg, Pendulum.rotation, 0);
  if not IncToLim(Pendulum.timecount1, Pendulum.timer) then
    Pendulum.timecount1:= 0;
    Pendulum.rotation:= Pendulum.rotation + Pendulum.rot_inc;
    if (Pendulum.rotation <= 401 - 46) or (Pendulum.rotation >= 401 + 46) then
      // Pendelrichtung umkehren
      Pendulum.rot_inc:= -Pendulum.rot_inc;
    endif;
    // in Endstellungen abbremsen
    if (Pendulum.rot_inc > 0) then
      if Pendulum.rotation < 401 + 38 then  // aufsteigend
        Pendulum.timer:= 0;
      else
        Pendulum.timer:= 2;
      endif;
    else
      if Pendulum.rotation > 401 - 38 then
        Pendulum.timer:= 0;
      else
        Pendulum.timer:= 2;
      endif;
    endif;
 endif;
end;

procedure CreatePendulum;
begin
  // Pendel
  Pendulum.rotation:= 401;
  Pendulum.rot_inc:= 1;
  Pendulum.timecount1:= 0;
  Pendulum.timer:= 1;      // alle n SysTicks auführen
  Pendulum.vecupd_start:= VE_NextVector;
  UpdatePendulum;
  VE_DrawCircleSegmentAt_b(0, 80, 8, 0, 360, VE_beammid); // auf Mittelposition unten
  VE_MoveTo_b(0, 10);
  VE_DrawLineTo_b(0, 72, VE_beamlow);   // Mittelpunkt minus Radius
  Pendulum.vecupd_end:= VE_NextVector;
  VE_SetRotationDeg(0);     // 1 Vektor
end;

// #############################################################################
// #############################################################################
// #############################################################################


Procedure NewRandomIncToMid(var object: t_animobject);
var my_rand_i, attractor: Integer;
begin
  my_rand_i:= Integer(RandomInt and 15) - 8;  // - 2000..2000
  // mit Random-Attraktor zur Mitte
  attractor:= (object.x_pos div 300);
  if Bit(RandomInt, 13) then
    object.x_inc:= my_rand_i;
    if my_rand_i > 0 then
      object.x_inc:= object.x_inc - attractor;
    endif;
    if my_rand_i < 0 then
      object.x_inc:= object.x_inc + attractor;
    endif;
    if object.x_inc = 0 then
      inc(object.x_inc);
    endif;
  endif;

  if Bit(RandomInt, 9) then
    object.y_inc:= my_rand_i;
  endif;

  if Second > 50 then
    inc(object.x_inc); // nach einer Minute verschwinden lassen
  endif;
end;

Procedure NewRandomIncSlow(var object: t_animobject);
var my_rand_i, attractor: Integer;
begin
  my_rand_i:= (RandomInt div 8) - 2048;  // -2048..2048
  if Bit(my_rand_i, 5) then
    object.x_inc:= my_rand_i and 3;
  else
    object.x_inc:= (my_rand_i and 3) - 4;
  endif;
  if Bit(my_rand_i, 8) then
    object.y_inc:= my_rand_i and 3;
  else
    object.y_inc:= (my_rand_i and 3) - 4;
  endif;
end;

Procedure NewRandomPos(var object: t_animobject);
var my_rand_i: Integer;
begin
  my_rand_i:= (RandomInt div 8) - 2048;  // -2048..2048
  if Bit(my_rand_i, 5) then
    object.x_pos:= -1950;
    object.y_pos:= my_rand_i;
  else
    object.x_pos:= 1950;
    object.y_pos:= my_rand_i;
  endif;
  if Bit(my_rand_i, 8) then
    object.x_pos:= my_rand_i;
    object.y_pos:= -1700;
  else
    object.x_pos:= my_rand_i;
    object.y_pos:= 1700;
  endif;
end;


Procedure SkipObjectIfInvisible(var object: t_animobject);
// Setzt einen JUMP auf vecupd_start ans Ende der Objekt-Vektoren wenn unsichtbar
// ansonsten ein NOP auf vecupd_start wenn sichtbar
// Erhöht Zähler um 1 Vektor
begin
  VE_UploadBegin(object.vecupd_start);
  if object.visible then
    VE_UploadVals(ve_skip, 0, 0);  // Dummy, Vektor 0, ggf durch JUMP ersetzt
  else
    // skip Object, JUMP to end
    VE_UploadVals(ve_jump, object.vecupd_end + 1, 0);
  endif;
end;


// #############################################################################
// ###                               U F O                                   ###
// #############################################################################

Procedure UpdateUfo;
begin
  if Ufo.trigger then
    Ufo.trigger:= false;
    NewRandomPos(Ufo);
    NewRandomIncToMid(Ufo);
    Ufo.visible:= true;
    Ufo.timeout1:= Integer(Random and $1FF) + 80;
    Ufo.timeout2:= Integer(Random and $1FF) + 50;
    Ufo.timecount1:= 0;
    Ufo.timecount2:= 0;
  endif;

  if Ufo.visible then
    inc(Ufo.timecount1); // Shoot-Timer
    if (Ufo.timecount1 > Ufo.timeout1) then
      Ufo.timeout1:= Integer(Random and $1FF) + 80;
      Ufo.timecount1:= 0;

      NewRandomIncToMid(Shoot);
      Shoot.trigger:= true;
      Shoot.timeout1:= Integer(Random and $7F) + 50;
    endif;
    // Richtungsänderungen nur, wenn Schuss beendet ist
    if (not ShootFlareActive) then
      inc(Ufo.timecount2); // Richtungs-Timer
      if (Ufo.timecount2 > Ufo.timeout2)  then
        Ufo.timeout2:= Integer(Random and $1FF) + 50;
        Ufo.timecount2:= 0;
        NewRandomIncToMid(Ufo);
      endif;
    endif;
    Ufo.x_pos:= Ufo.x_pos + Ufo.x_inc;
    Ufo.y_pos:= Ufo.y_pos + Ufo.y_inc;

    if abs(Ufo.x_pos) > 2000 then
      Ufo.visible:= false;
    endif;
    if abs(Ufo.y_pos) > 1700 then
      Ufo.y_inc:= -Ufo.y_inc;
    endif;
  endif;

  SkipObjectIfInvisible(Ufo);
  // Ufo wurde an Position 0,0 geplottet, Position über Offset
  VE_UploadVals(ve_move_abs, 0,0);
  VE_UploadVals(ve_set_offs, Ufo.x_pos, Ufo.y_pos);
end;

Procedure UpdateShoot;
var my_scale: Integer;  // Shoot Animation
begin
  if Shoot.trigger then
    Shoot.trigger:= false;
    Shoot.visible:= true;
    Shoot.x_pos:= Ufo.x_pos;
    Shoot.y_pos:= Ufo.y_pos;
    Shoot.timecount1:= 0;
  endif;

  if Shoot.visible then
    Shoot.x_pos:= Shoot.x_pos + Shoot.x_inc;
    Shoot.y_pos:= Shoot.y_pos + Shoot.y_inc;
    Inc(Shoot.timecount1);
    if Shoot.timecount1 > Shoot.timeout1 then
      Shoot.visible:= false;
      Flare.trigger:= true;
      CheckDamage; // Treffer auswerten
    endif;
  endif;
  SkipObjectIfInvisible(Shoot); // 1 Vektor
  VE_DrawPinPointAt(Shoot.x_pos, Shoot.y_pos, VE_beamhi, 20); // 3 Vektoren!
end;

Procedure UpdateFlare;
var my_scale: Integer;  // Flare Animation
begin
  if Flare.trigger then
    Flare.trigger:= false;
    Flare.visible:= True;
    Flare.timecount1:= 0;
    Flare.rotation:= RandomInt shr 8;
    Flare.x_pos:= Shoot.x_pos;
    Flare.y_pos:= Shoot.y_pos;
  endif;

  SkipObjectIfInvisible(Flare);  // Vektor 0
  if Flare.visible then
    inc(Flare.timecount1);
    if Flare.timecount1 >  Flare.timeout1 then
      Flare.visible:= false;
    endif;
    my_scale:= Flare.timecount1 * 4 + 100;
    VE_UploadVals(ve_set_offs, Flare.x_pos, Flare.y_pos); // Vektor 1
    VE_UploadVals(ve_set_scale, my_scale, my_scale);      // Vektor 2
    VE_UploadVals(ve_set_rot_deg, Flare.rotation, 0);     // Vektor 3
    if Bit(Flare.rotation, 0) then // Zufallswert!
      VE_DrawPinPointAt_b(-100, 0, VE_beamhi); // Besteht aus je 3 Befehlen!
      VE_DrawPinPointAt_b(-40, 20, VE_beammid);
      VE_DrawPinPointAt_b(-80, -40, VE_beammid);
      VE_DrawPinPointAt_b(-20, -70, VE_beamhi);
      VE_DrawPinPointAt_b(90, 0, VE_beamhi);
      VE_DrawPinPointAt_b(20, 100, VE_beamhi);
      VE_DrawPinPointAt_b(40, -70, VE_beammid);
      VE_DrawPinPointAt_b(30, -50, VE_beamhi); // insg. 24 Vektoren
    else
      VE_DrawPinPointAt_b(-80, 10, VE_beamhi); // Besteht aus je 3 Befehlen!
      VE_DrawPinPointAt_b(-30, 30, VE_beammid);
      VE_DrawPinPointAt_b(-80, -40, VE_beamhi);
      VE_DrawPinPointAt_b(-70, -70, VE_beammid);
      VE_DrawPinPointAt_b(90, 20, VE_beamhi);
      VE_DrawPinPointAt_b(50, 90, VE_beamhi);
      VE_DrawPinPointAt_b(20, -20, VE_beamhi);
      VE_DrawPinPointAt_b(30, -100, VE_beamhi); // insg. 24 Vektoren
    endif;
  endif;
end;

Procedure UpdateUfoAnimation;
begin
  UpdateUfo;
  UpdateShoot;
  UpdateFlare;
end;

// #############################################################################

Procedure CreateUfoAnimation;
begin
  Ufo.visible:= false;
  UfoActive:= false;
  Ufo.x_inc:= 2;
  Ufo.y_inc:= 1;
  Ufo.timecount1:= 0;  // keine autom. Aktionen
  Ufo.timecount2:= 0;
  Ufo.timeout1:= 9999;  // keine autom. Aktionen
  Ufo.timeout2:= 9999;
  Ufo.vecupd_start:= SPI_GetCurrentVec;
  VE_UploadVals(ve_skip, 0, 0);  // Dummy, erster Vektor, ggf durch JUMP ersetzt
  VE_UploadVals(ve_move_abs, 0, 0);
  VE_UploadVals(ve_set_offs, Ufo.x_pos, Ufo.y_pos);
  VE_SetBeamInt(VE_beamhi);
  VE_UploadVals(ve_set_speed, 32, 0);
  VE_DrawROMvecArrRel(@c_UfoArr, 60);
  // Ufo wurde an Position 0,0 geplottet, Position über Offset
  VE_UploadVals(ve_set_speed, 16, 0);
  VE_UploadVals(ve_set_scale, 1024, 1024);
  VE_UploadVals(ve_set_offs, 0, 0);
  Ufo.vecupd_end:= SPI_GetCurrentVec; // Zeigt auf Vektor NACH Ufo
  VE_NextVector:= Ufo.vecupd_end;

  Shoot.visible:= false;  // damit Vektoren eingetragen werden
  Shoot.trigger:= false;
  Shoot.timecount1:= 0;
  Shoot.vecupd_start:= VE_NextVector;
  inc(VE_NextVector, 4);
  Shoot.vecupd_end:= VE_NextVector; // Zeigt auf Vektor NACH Shoot

  Flare.visible:= False;  // damit Vektoren eingetragen werden
  Flare.timecount1:= 0;
  Flare.timeout1:= 120;
  Flare.vecupd_start:= VE_NextVector;
  inc(VE_NextVector, 28); // 28 Vektoren für Flare
  VE_UploadBegin(VE_NextVector);
  VE_UploadVals(ve_set_scale, 1024, 1024);     // Vektor 27
  VE_UploadVals(ve_set_offs, 0, 0);            // Vektor 28
  VE_UploadVals(ve_set_rot_deg, 0, 0);         // Vektor 29
  Flare.vecupd_end:= VE_NextVector; // Zeigt auf Vektor NACH Flare

  SkipObjectIfInvisible(Ufo);   // ist hier noch unsichbar, JUMP eintragen
  SkipObjectIfInvisible(Shoot);
  SkipObjectIfInvisible(Flare);
  // Ende der Animationsvektoren
  VE_UploadBegin(Flare.vecupd_end);
end;

// #############################################################################
// ###                      B O T T O M   L O G O                            ###
// #############################################################################

Procedure UpdateLogo;
begin
  if Logo.damage_level = 0 then
    Logo.x_inc:= 8;
    Logo.x_scale:= 1024;
    Logo.timer:= 1;
    Logo.rot_inc:= 1;
    Logo.rotation:= 0;
  else
    inc(Logo.x_scale, Logo.x_inc);
    if Logo.x_scale > 1024 then
      Logo.x_inc:= -8;
    endif;
    if Logo.x_scale < -1024 then
      Logo.x_inc:= 8;
    endif;
    if Logo.damage_level > 1 then
      if not inctolim(Logo.timecount1, Logo.timer) then
        Logo.timecount1:= 0;
        Dec(Logo.rotation, Logo.rot_inc);
        if Logo.rotation < 0 then
          Logo.rotation:= 359;
        endif;
      endif;
    endif;
  endif;
  VE_UploadBegin(Logo.vecupd_start);
  VE_SetRotationDeg(Logo.rotation);
  VE_UploadVals(ve_set_rot_mid, 220, 220);
  VE_UploadVals(ve_set_offs, -1450 - Logo.x_scale div 3, -1650);
  VE_UploadVals(ve_set_scale, Logo.x_scale, 1024);
end;

Procedure CreateLogo;
var logo_x: Int8;
begin
  Logo.vecupd_start:= VE_NextVector;
  UpdateLogo;
  logo_x:= 0;
{$IFDEF MAKEMAGAZIN}
  VE_SetBeamInt(VE_beammid);
  VE_DrawStringAt_b(0, 10, 'MAKE:', 38);
  VE_DrawStringAt_b(0, 0, 'MAGAZIN', 25);
{$ELSE}
  VE_SetBeamInt(VE_beammid);
  VE_DrawStringAt_b(0, 21, 'KEY', 38);
  VE_DrawStringAt_b(0, 10, 'BOARD', 34);
  VE_DrawStringAt_b(0, 0, 'PARTNER', 25);
{$ENDIF}
  VE_UploadVals(ve_set_scale, 1024, 1024);
  VE_SetOffset_b(0, 0);
  VE_SetRotationMid_b(0, 0);
  VE_SetRotationDeg(0);
end;

// #############################################################################
// ###                          M I D  L O G O                               ###
// #############################################################################

Procedure UpdateRotatingText;
var
  my_tick: Boolean;
begin
  if not inctolim(RotatingText.timecount1, RotatingText.timer) then
    RotatingText.timecount1:= 0;
  endif;
  my_tick:= RotatingText.timecount1 = 0;

  if my_tick then
    Dec(RotatingText.rotation, RotatingText.rot_inc);
    if RotatingText.rotation < 0 then
      RotatingText.rotation:= 359;
    endif;
  endif;

  case RotatingText.damage_level of
  0:
    RotatingText.rotation:= 0;
    RotatingText.y_pos:= -600;
    RotatingText.timer:= 2;
    RotatingText.rot_inc:= 1;
    |
  1:
    RotatingText.timer:= 1;
    |
  else
    RotatingText.rot_inc:= 2;
    dec(RotatingText.y_pos, 10);
    if RotatingText.y_pos < -1800 then
      RotatingText.y_pos:= -1800;
      RotatingText.rot_inc:= 0;
    endif;
    if my_tick then
      inctolim(RotatingText.timer, 10);
    endif;
  endcase;
  VE_UploadBegin(RotatingText.vecupd_start);
  VE_SetRotationDeg(RotatingText.rotation);
  VE_UploadVals(ve_set_offs, 0, RotatingText.y_pos);
end;

Procedure CreateRotatingText;
// Rotierender Text
begin
  RotatingText.vecupd_start:= VE_NextVector;
  UpdateRotatingText;
{$IFDEF MAKEMAGAZIN}
  VE_SetBeamInt(VE_beammid);
  VE_SetRotationMid_b(0, 8); // Mitte der Schrift: 8 bei 70%
  VE_DrawStringAt_b(-30, 0, 'HEINZ', 65);  // setzt scale neu!
{$ELSE}
  VE_SetBeamInt(VE_beammid);
  VE_SetRotationMid_b(0, 6); // Mitte der Schrift: 6 bei 50%
  VE_DrawStringAt_b(-38, 0, 'HX3 TIME', 50);  // setzt scale neu!
{$ENDIF}
  VE_SetRotationMid_b(0, 0);
  VE_SetRotationDeg(0);
  VE_UploadVals(ve_set_scale, 1024, 1024);
  VE_UploadVals(ve_set_offs, 0, 0);
  RotatingText.vecupd_end:= VE_NextVector;
end;

// #############################################################################
// ###                       ´      D A T U M                                ###
// #############################################################################

procedure UpdateDatePos;
// Achtung: Unterschiedliche Anzahl der Vektoren je nach Datum!
var
  date_str: String[11];
begin
  if DateDisplay.damage_level = 0 then
    DateDisplay.x_inc:= 8;
    DateDisplay.x_scale:= 1024;
    DateDisplay.timer:= 1;
    DateDisplay.rot_inc:= 1;
    DateDisplay.rotation:= 0;
  else
    inc(DateDisplay.x_scale, DateDisplay.x_inc);
    if DateDisplay.x_scale > 1024 then
      DateDisplay.x_inc:= -8;
    endif;
    if DateDisplay.x_scale < -1024 then
      DateDisplay.x_inc:= 8;
    endif;
    if DateDisplay.damage_level > 1 then
      DateDisplay.rot_inc:= 2;
      if not inctolim(DateDisplay.timecount1, DateDisplay.timer) then
        DateDisplay.timecount1:= 0;
        Dec(DateDisplay.rotation, DateDisplay.rot_inc);
        if DateDisplay.rotation < 0 then
          DateDisplay.rotation:= 359;
        endif;
      endif;
    endif;
  endif;
  VE_UploadBegin(DateDisplay.vecupd_start);  // wird komplett ersetzt
  VE_SetRotationDeg(DateDisplay.rotation);
  VE_UploadVals(ve_set_rot_mid, 0, 100);
  VE_UploadVals(ve_set_offs, 0, 800);
  VE_UploadVals(ve_set_scale, DateDisplay.x_scale, 1024);
end;

procedure UpdateDateString;
// Achtung: Unterschiedliche Anzahl der Vektoren je nach Datum!
var
  date_str: String[11];
begin
  VE_UploadBegin(DateDisplay.vecupd_redraw);  // wird komplett ersetzt
  date_str:= ByteToStr(Byte(Day):2:'0') + '.' + ByteToStr(Byte(Month):2:'0')
             + '.20' + ByteToStr(Byte(Year):2:'0');
  VE_SetBeamInt(VE_beammid);
  VE_DrawStringAt_b(-45, 0, date_str, 50);
  VE_UploadVals(ve_jump, DateDisplay.vecupd_end, 0);  // skip garbage, JUMP to end
end;


procedure CreateDate;
var temp_addr: Integer;
// Achtung: Unterschiedliche Anzahl der Vektoren je nach Datum!
// Deshalb wird zunächst eine Liste mit den meisten Vektoren gebildet,
// die später überschrieben und mit einem Jump ans Ende versehen wird.
begin
  DateDisplay.vecupd_start:= VE_NextVector;
  UpdateDatePos;
  DateDisplay.vecupd_redraw:= VE_NextVector;
  VE_SetBeamInt(VE_beamlow);
  VE_DrawStringAt_b(0, 0, '88:88:8888', 50);  // mögl. viele Vektoren
  VE_UploadVals(ve_skip, 0, 0);
  VE_UploadVals(ve_skip, 0, 0);
  DateDisplay.vecupd_end:= VE_NextVector;
  VE_SetOffset_b(0, 0);
  VE_SetRotationDeg(0);
  VE_UploadVals(ve_set_scale, 1024, 1024);  // wurde geändert
  VE_UploadVals(ve_set_rot_mid, 0, 0);
end;

// #############################################################################
// ###                    ´      W E E K D A Y                               ###
// #############################################################################

procedure UpdateWeekdayPos;
begin
  if WeekdayDisplay.damage_level = 0 then
    WeekdayDisplay.x_inc:= 5;
    WeekdayDisplay.x_scale:= 1024;
    WeekdayDisplay.timer:= 1;
    WeekdayDisplay.rot_inc:= 1;
    WeekdayDisplay.rotation:= 0;
  else
    WeekdayDisplay.rot_inc:= 2;
    inc(WeekdayDisplay.x_scale, WeekdayDisplay.x_inc);

    if WeekdayDisplay.x_scale > 1024 then
      WeekdayDisplay.x_inc:= -5;
    endif;
    if WeekdayDisplay.x_scale < -1024 then
      WeekdayDisplay.x_inc:= 5;
    endif;
    if WeekdayDisplay.damage_level > 1 then
      WeekdayDisplay.rot_inc:= 3;
      if not inctolim(WeekdayDisplay.timecount1, WeekdayDisplay.timer) then
        WeekdayDisplay.timecount1:= 0;
        Dec(WeekdayDisplay.rotation, WeekdayDisplay.rot_inc);
        if WeekdayDisplay.rotation < 0 then
          WeekdayDisplay.rotation:= 359;
        endif;
      endif;
    endif;
  endif;
  VE_UploadBegin(WeekdayDisplay.vecupd_start);  // wird komplett ersetzt
  VE_SetRotationDeg(WeekdayDisplay.rotation);
  VE_UploadVals(ve_set_rot_mid, 0, 50);
  VE_UploadVals(ve_set_offs, 0, 1050);
  VE_UploadVals(ve_set_scale, WeekdayDisplay.x_scale, 1024);
end;


procedure UpdateWeekday;
// Achtung: Unterschiedliche Anzahl der Vektoren je nach Datum!
var
  wd_str: String[11];
begin
  VE_UploadBegin(WeekdayDisplay.vecupd_redraw);  // wird komplett ersetzt
  wd_str:= c_WeekdayArr[Weekday];
  VE_SetBeamInt(VE_beamlow);
  VE_DrawStringAt_b(-Int8(length(wd_str) * 3) - 4, 0, wd_str, 35);
  VE_UploadVals(ve_jump, WeekdayDisplay.vecupd_end, 0);  // skip garbage, JUMP to end
end;


procedure CreateWeekday;
var temp_addr: Integer;
// Achtung: Unterschiedliche Anzahl der Vektoren je nach Datum!
// Deshalb wird zunächst eine Liste mit den meisten Vektoren gebildet,
// die später überschrieben und mit einem Jump ans Ende versehen wird.
begin
  WeekdayDisplay.vecupd_start:= VE_NextVector;
  UpdateWeekdayPos;  // Positionsdaten eintragen
  WeekdayDisplay.vecupd_redraw:= VE_NextVector;
  VE_SetBeamInt(VE_beamlow);
  VE_DrawStringAt_b(-34, 0, '8888888888', 35);  // mögl. viele Vektoren
  VE_UploadVals(ve_skip, 0, 0);
  WeekdayDisplay.vecupd_end:= VE_NextVector;
  VE_SetOffset_b(0, 0);
  VE_SetRotationDeg(0);
  VE_UploadVals(ve_set_scale, 1024, 1024);  // wurde geändert
  VE_UploadVals(ve_set_rot_mid, 0, 0);
end;


// #############################################################################
// ###                    ´       D A M A G E                                ###
// #############################################################################

Procedure CheckDamage;
var xb, yb: Int8;
begin
  xb:= Int8(Shoot.x_pos div 16);
  yb:= Int8(Shoot.y_pos div 16);
  if valueinrange(xb, -55, 55) and valueinrange(yb, -45, -20) then
    inctolimwrap(RotatingText.damage_level, 3, 0);
  elsif valueinrange(xb, -128, -60) and valueinrange(yb, -128, -60) then
    inctolim(Logo.damage_level, 3);
  elsif valueinrange(xb, -55, 55) and valueinrange(yb, 38, 60) then
    inctolimwrap(DateDisplay.damage_level, 3, 0);
    if DateDisplay.damage_level = 0 then
      DateDisplay.rotation:= 0;
    else
      DateDisplay.rotation:= 15;
    endif;
  elsif valueinrange(xb, -50, 50) and valueinrange(yb, 61, 90) then
    inctolimwrap(WeekdayDisplay.damage_level, 3, 0);
    if WeekdayDisplay.damage_level = 0 then
      WeekdayDisplay.rotation:= 0;
    else
      WeekdayDisplay.rotation:= 15;
    endif;
  endif;
end;

procedure RestoreDamage;
begin
  RotatingText.damage_level:= 0;
  UpdateRotatingText;
  Logo.damage_level:= 0;
  UpdateLogo;
  DateDisplay.damage_level:= 0;
  UpdateDatePos;
  WeekdayDisplay.damage_level:= 0;
  UpdateWeekdayPos;
end;

procedure UpdateDamage;
begin
  if RotatingText.damage_level > 0 then
    UpdateRotatingText;
  endif;
  if Logo.damage_level > 0 then
    UpdateLogo;
  endif;
  if DateDisplay.damage_level > 0 then
    UpdateDatePos;
  endif;
  if WeekdayDisplay.damage_level > 0 then
    UpdateWeekdayPos;
  endif;
end;

// #############################################################################

procedure SendButton(button: Byte; state: Boolean);
var btn_temp: Byte;
begin
  btn_temp:= 0;
  incl(btn_temp, button);
  SPI_LoaderCmd(lc_port1, Integer(btn_temp));
end;

procedure SendButtonPulse(button: Byte; on_time: Word);
var btn_temp: Byte;
begin
  btn_temp:= 0;
  incl(btn_temp, button);
  SPI_LoaderCmd(lc_port1, Integer(btn_temp));
  mdelay(on_time);
  SPI_LoaderCmd(lc_port1, 0);
  mdelay(50);
end;

Procedure CreateTimeDigits;
begin
  VE_DefaultVectors(ve_beammid);
  VE_DrawStringAt_b(-120, -105, ByteToStr(Hour:2:'0') + ':' + ByteToStr(Minute:2:'0'), 50);
end;

// #############################################################################
// ###                         SPLASH SEQUENCE                               ###
// #############################################################################

procedure UpdateFileObject(object_nr: Byte);
// Vektor-Datei enthält evt. für jedes Vektor-Objekt eine eigene Init-Sequenz,
// die bei VectorLoad() FileObjects-Einträge erzeugt und FileObjectCount
// auf die Anzahl der Objekte setzt.
var rot: Integer;
  offs_x, offs_y: Integer;
  scale_x, scale_y: Integer;
begin
  if object_nr < FileObjectCount then
    offs_x:= FileObjects[object_nr].x_offs + Integer(FileObjects[object_nr].x_inc);
    FileObjects[object_nr].x_offs:= offs_x;
    offs_y:= FileObjects[object_nr].y_offs + Integer(FileObjects[object_nr].y_inc);
    FileObjects[object_nr].y_offs:= offs_y;

    scale_x:= FileObjects[object_nr].x_scale + Integer(FileObjects[object_nr].x_scale_inc);
    FileObjects[object_nr].x_scale:= scale_x;
    scale_y:= FileObjects[object_nr].y_scale + Integer(FileObjects[object_nr].y_scale_inc);
    FileObjects[object_nr].y_scale:= scale_y;

    rot:= FileObjects[object_nr].rotation + Integer(FileObjects[object_nr].rot_inc);
    if rot > 359 then
      rot:= 0;
    endif;
    if rot < 0 then
      rot:= 359;
    endif;
    FileObjects[object_nr].rotation:= rot;

    VE_UploadBegin(FileObjects[object_nr].vecupd_start + 1);  // BEAM
    // sehr kleine Objekte oder solche außerhalb Sichtfeld verschwinden lassen
    if (scale_x < 100) or (scale_y < 100) or (abs(offs_x) > 1950) or (abs(offs_y) > 1950) then
      VE_SetBeamInt(ve_beamoff);
    else
      VE_SetBeamInt(FileObjects[object_nr].beam);
    endif;
    VE_UploadVals(ve_set_scale, scale_x, scale_y); // SCALE
    VE_UploadVals(ve_set_offs, offs_x, offs_y); // OFFSET
    VE_SetRotationDeg(rot); // ROTATION
  endif;
end;

procedure UpdateAllFileObjects;
var
  idx: Byte;
begin
  if FileObjectCount > 0 then
    for idx:= 0 to FileObjectCount - 1 do
      UpdateFileObject(idx);
    endfor;
  endif;
end;

// #############################################################################

function AppearFileAnimation: boolean;
// Helligkeit jedes einzelnen Objektes schrittweise erhöhen
// SPLASH.VEC und ANIM_xx.VEC enthalten für jedes Vektor-Objekt eine eigene Init-Sequenz
var
  timeout: Integer;
  idx, beam: Byte;
begin
  VE_UploadBegin(FileVecs.vecupd_end);
  VE_DefaultVectors(VE_beamhi);
  CreateTimeDigits;
  VE_UploadVals(ve_stopwait, 0, 0);
  for idx:= 0 to FileObjectCount - 1 do
    FileObjectSavedBeams[idx]:= FileObjects[idx].beam; // Endwert
    beam:= VE_beamlow div 2; // fast unsichtbar
    FileObjects[idx].beam:= beam;
    VE_UploadBegin(FileObjects[idx].vecupd_start + 1);  // auf Beam-Vector
    VE_SetBeamInt(beam); // fast unsichtbar
  endfor;
  VE_Run(0);
  for idx:= 0 to FileObjectCount - 1 do
    for timeout:= VE_beamlow div 2 to VE_beamhi do
      beam:= FileObjects[idx].beam;
      VE_UploadBegin(FileObjects[idx].vecupd_start + 1);  // auf Beam-Vector
      VE_SetBeamInt(beam);
      if beam < FileObjectSavedBeams[idx] then
        FileObjects[idx].beam:= beam + 1;
      else
        break;
      endif;
      if Chores then // 10 ms Delay
        return(true);
      endif;
    endfor;
  endfor;
  return(true);
end;

// #############################################################################

procedure new_object_slides(shift_mult: Byte);
var
  offs: Integer;
  idx : Byte;
begin
  for idx:= 0 to FileObjectCount - 1 do
    offs:= Integer(shift_mult) * 25;
    VE_UploadBegin(FileObjects[idx].vecupd_start + 3);  // auf Offset-Vector
    case idx mod 4 of
    0:
      VE_UploadVals(ve_set_offs, offs, offs);         // #3
      // VE_SetRotationDeg(timeout);
      |
    1:
      VE_UploadVals(ve_set_offs, offs, -offs);         // #3
      // VE_SetRotationDeg(timeout div 2);
      |
    2:
      VE_UploadVals(ve_set_offs, -offs, offs);         // #3
      // VE_SetRotationDeg(-timeout);
     |
    3:
      VE_UploadVals(ve_set_offs, -offs, -offs);         // #3
      // VE_SetRotationDeg(timeout * 2);
      |
    endcase;
  endfor;
end;

function SlideInFileAnimation: boolean;
// SPLASH.VEC und ANIM_xx.VEC enthalten für jedes Vektor-Objekt eine eigene Init-Sequenz
var
  timeout: Byte;
begin
  VE_UploadBegin(FileVecs.vecupd_end);
  VE_DefaultVectors(VE_beamhi);
  CreateTimeDigits;
  VE_UploadVals(ve_stopwait, 0, 0);
  new_object_slides(75);
  VE_Run(0);
  for timeout:= 74 downto 0 do
    new_object_slides(timeout);
    if Chores then // 10 ms Delay
      return(true);
    endif;
  endfor;
  return(true);
end;

// #############################################################################

function DestroyFileAnimation: boolean;
// SPLASH.VEC und ANIM_xx.VEC enthalten für jedes Vektor-Objekt eine eigene Init-Sequenz
var
  timeout: Integer;
begin
  VE_UploadBegin(FileVecs.vecupd_end);
  VE_DefaultVectors(VE_beamhi);
  CreateUfoAnimation;
  CreateTimeDigits;
  VE_UploadVals(ve_stopwait, 0, 0);
  VE_Run(0);
  ChoresDelay(100); // 1 Sekunde
  for i:= 0 to FileObjectCount - 1 do
    FileObjects[i].x_inc:= Int8(RandomRange(0, 30) - 15);
    FileObjects[i].y_inc:= Int8(RandomRange(0, 30) - 15);
    FileObjects[i].x_scale_inc:= -Int8(RandomRange(2, 7));
    FileObjects[i].y_scale_inc:= -Int8(RandomRange(2, 7));
    FileObjects[i].rot_inc:= Int8(RandomRange(0, 9) - 5);
  endfor;
  Ufo.visible:= true;
  Ufo.y_inc:= Integer(Random and 7) - 3;
  if (Random and 1) = 1 then
    Ufo.x_pos:= 1950;
    Ufo.y_pos:= 600;
    Ufo.x_inc:= -15;
  else
    Ufo.x_pos:= -1950;
    Ufo.y_pos:= 800;
    Ufo.x_inc:= 12;
  endif;
  for timeout:= 0 to 140 do
    UpdateUfoAnimation;
    if Chores then // 10 ms Delay
      return(true);
    endif;
  endfor;
  Shoot.trigger:= true;
  Shoot.timeout1:= 70;
  Shoot.x_inc:= Integer(Random and 15) + 3;
  Shoot.y_inc:= -10;
  for timeout:= 0 to 70 do
    UpdateUfoAnimation;
    if Chores then // 10 ms Delay
      return(true);
    endif;
  endfor;

  for timeout:= 0 to 250 do
    UpdateAllFileObjects;
    UpdateUfoAnimation;
    if Chores then // 10 ms Delay
      return(true);
    endif;
  endfor;
  return(true);
end;

// #############################################################################

procedure SplashSequence1;
// Bild anzeigen und UFO-Animation mit Abschuss
// Vektordaten MIT Initialisierungssequenz, aber ohne JUMP 0 am Ende erstellen,
// diese werden im Laufe der Sequenz überschrieben
begin
  // Vektor-Routinen einmal komplett uploaden und Einsprungadressen merken
  if not VectorLoad('ANIM_' + ByteToStr(AnimNr) + '.VEC', 0) then
    AnimNr:= 0;
    VectorLoad('ANIM_0.VEC', 0);
  endif;
  VE_UploadBegin(FileVecs.vecupd_end);
  VE_DefaultVectors(VE_beamhi);
  CreateTimeDigits;
  VE_UploadVals(ve_stopwait, 0, 0);
  if (RandomInt and 1) = 1 then
    SlideInFileAnimation;
  else
    AppearFileAnimation;
  endif;
  VE_Stop;
  DestroyFileAnimation;
  IncToLimWrap(AnimNr, 19, 0);
  if DS_present then
    DS_GetTime(Second, Minute, Hour);
    SetRTCtime;
  endif;
  Sec100:= 0;
  Pendulum.rotation:= 401;
  write(SerOut,'/ Sequ 1 done');
  SerCRLF;
end;

procedure SplashSequence2;
// Bild verlangsamt "malen" und anzeigen
// Vektordaten MIT Initialisierungssequenz, aber ohne JUMP 0 am Ende erstellen,
// diese werden im Laufe der Sequenz überschrieben
var
  timeout: Byte;
begin
  // Vektor-Routinen einmal komplett uploaden und Einsprungadressen merken
  if not VectorLoad('LOGO_' + ByteToStr(LogoNr) + '.VEC', 0) then
    LogoNr:= 0;
    VectorLoad('LOGO_0.VEC', 0);
  endif;
  // VE_UploadBegin(FileVecs.vecupd_end); // bereits gesetzt
  VE_UploadVals(ve_stopwait, 0, 0);
  VE_UploadBegin(6);    // Speed
  VE_UploadVals(ve_set_speed, 2000, 0);
  VE_Run(0);
  repeat
  until VEC_DONE;
  // mit normaler Geschwindigkeit anzeigen, UFO-Animation
  VE_UploadBegin(6);    // Speed
  VE_UploadVals(ve_set_speed, 8, 0);
  DestroyFileAnimation;  // nicht neu laden
  IncToLimWrap(LogoNr, 19, 0);
  if DS_present then
    DS_GetTime(Second, Minute, Hour);
    SetRTCtime;
  endif;
  Sec100:= 0;
  Pendulum.rotation:= 401;
  write(SerOut,'/ Sequ 2 done');
  SerCRLF;
end;

procedure SplashSequence3;
// Bild schwillt an, anzeigen, Bild fällt in sich zusammen
// Vektordaten MIT Initialisierungssequenz, aber ohne JUMP 0 am Ende erstellen,
// diese werden im Laufe der Sequenz überschrieben
var
  x_scale, y_scale: Integer;
begin
  // Vektor-Routinen einmal komplett uploaden und Einsprungadressen merken
  if not VectorLoad('LOGO_' + ByteToStr(LogoNr) + '.VEC', 0) then
    LogoNr:= 0;
    VectorLoad('LOGO_0.VEC', 0);
  endif;
  IncToLimWrap(LogoNr, 19, 0);
  CreateTimeDigits;
  VE_UploadVals(ve_stopwait, 0, 0);
  x_scale:= 32;
  y_scale:= 32;
  VE_UploadBegin(2);    // Scale auf Adresse 2
  VE_UploadVals(ve_set_scale, x_scale, y_scale);
  VE_Run(0);
  repeat
    x_scale:= mulDivInt(x_scale, 104, 100);
    y_scale:= mulDivInt(y_scale, 104, 100);
    VE_UploadBegin(2);
    VE_UploadVals(ve_set_scale, x_scale, y_scale);
  until Chores or (x_scale > 1024);
  ChoresDelay(100);
  repeat
    y_scale:= mulDivInt(y_scale, 97, 100);
    if y_scale < 80 then
      x_scale:= mulDivInt(x_scale, 90, 100);
    endif;
    VE_UploadBegin(2);
    VE_UploadVals(ve_set_scale, x_scale, y_scale); // #1
  until Chores or (x_scale < 20);
  ChoresDelay(10);
  VE_Stop;
  if DS_present then
    DS_GetTime(Second, Minute, Hour);
    SetRTCtime;
  endif;
  Sec100:= 0;
  Pendulum.rotation:= 401;
  write(SerOut,'/ Sequ 3 done');
  SerCRLF;
end;

// #############################################################################

Procedure SplashScreen;
// SPLASH.VEC enthält für jedes Vektor-Objekt eine eigene Init-Sequenz
begin
  VectorLoad('SPLASH.VEC', 0); // erzeugt FileObjects-Einträge
  DestroyFileAnimation;
  if DS_present then
    DS_GetTime(Second, Minute, Hour);
    SetRTCtime;
  endif;
  Sec100:= 0;
  Pendulum.rotation:= 401;
  write(SerOut,'/ Sequ Splash done');
  SerCRLF;
end;

// #############################################################################
// ###                    ´        C L O C K                                 ###
// #############################################################################


procedure CreateClock;
begin
  // vorhandene Objekte können während des Betriebs überschrieben werden
  // Vektor-Routinen einmal komplett uploaden und Einsprungadressen merken
  VE_Stop;
  VE_UploadBegin(0); // ab Adresse 0
  VE_DefaultVectors(ve_beammid);

  CreateClockFace;
  CreateSecondsHand;
  CreateMinutesHand;
  CreateHoursHand;
  CreateDate;
  CreateWeekday;
  CreateRotatingText;
  CreatePendulum;

  CreateLogo;
  CreateUfoAnimation;
  VE_UploadVals(ve_stopwait, 0, 0);

  UpdateRotatingText;
  UpdatePendulum;
  UpdateSecondsHand;
  UpdateMinutesHand;
  UpdateHoursHand;
  UpdateDatePos;
  UpdateDateString;
  UpdateWeekdayPos;
  UpdateWeekday;
  VE_Run(0);
end;

// #############################################################################
// ###                    ´        MAIN LOOP                                 ###
// #############################################################################

procedure InitScopeClock;
begin
  // InitPorts;
  // InitSPI;
  // EnableInts;

  DS_Init;

  DestDayCount:= EE_DestDayCount; // ab 1.1.2000
  DaysLeft:= DestDayCount - CalcDays(Day, Month, Year);
  RestoreDamage;
  For i:= 0 to 59 do
    n:= (i + 45) mod 60;
    m:= c_sinusArr[i];
    m:= muldivInt8(m, 85, 100);
    x_arrTicksOuter[i]:= m;
    y_arrTicksOuter[n]:= m;
    if i mod 5 = 0 then
      m:= muldivInt8(m, 90, 100);
    else
      m:= muldivInt8(m,95, 100);
    endif;
    m:= c_sinusArr[i];
  endfor;
  //InterpolateMinutes;
  if (Minute <> 0) then
    RandomSeed(Word(Minute shl 8) + Word(Second));
  else
    RandomSeed($2051);
  endif;
  SendByteToFPGA($80, 1); // Q1 Bit 7

  VE_InitVars;
  VE_Stop;

  LogoNr:= 0;
  State:= s_initclock;
{
  writeln(SerOut, '/ Loader Test');
  VE_UploadBegin(1700);
  WriteIntSer(SPI_GetCurrentVec);
  VE_UploadBegin(1710);
  WriteIntSer(SPI_GetCurrentVec);
  VE_UploadVals(ve_skip, 0, 0);  // Dummy, erster Vektor, ggf durch JUMP ersetzt
  WriteIntSer(SPI_GetCurrentVec);
  VE_UploadVals(ve_skip, 0, 0);  // Dummy, erster Vektor, ggf durch JUMP ersetzt
  WriteIntSer(SPI_GetCurrentVec);
  VE_UploadVals(ve_skip, 0, 0);  // Dummy, erster Vektor, ggf durch JUMP ersetzt
  WriteIntSer(SPI_GetCurrentVec);
  writeln(SerOut, '/ Test End');
}
  VE_UploadBegin(0);
end;

procedure IncDecByte(var value: Byte; change, limit: Int8);
begin
  if change > 0 then
    incToLim(value, limit);
  endif;
  if change < 0 then
    decToLim(value, 0);
  endif;
end;

procedure IncDecInt(var value: Integer; change: Int8; limit: Integer);
begin
  if change > 0 then
    incToLim(value, limit);
  endif;
  if change < 0 then
    decToLim(value, 0);
  endif;
end;


procedure SetItemVal(set_mode: t_setmode; change: Int8);
begin
  write(SerOut,'/ SetMode: ' + ByteToStr(Byte(set_mode)));
  write(SerOut,', Change: ' + IntToStr(change));
  SerCRLF;
  VE_Stop;
  VE_UploadBegin(0); // ab Adresse 0
  VE_DefaultVectors(ve_beammid);
  VE_DrawStringAt_b(-100, 40,'SETTINGS', 100);
  VE_SetBeamInt(VE_beamhi);
  if (set_mode <> s_run) and DS_present then
    DS_GetTime(Second, Minute, Hour);
    DS_GetDate(Weekday, Day, Month, Year);
  endif;
  case set_mode of
  s_hour:
    IncDecByte(Hour, change, 23);
    VE_DrawStringAt_b(-100, 0,'HOUR (24H): ' + ByteToStr(Hour), 80);
    SetRTCtime;
    DS_SetTime(Second, Minute, Hour);
    |
  s_minute:
    IncDecByte(Minute, change, 59);
    VE_DrawStringAt_b(-100, 0,'MINUTE: ' + ByteToStr(Minute), 80);
    SetRTCtime;
    DS_SetTime(Second, Minute, Hour);
    |
  s_second:
    IncDecByte(Second, change, 59);
    VE_DrawStringAt_b(-100, 0,'SECOND: ' + ByteToStr(Second), 80);
    SetRTCtime;
    DS_SetTime(Second, Minute, Hour);
    |
  s_weekday:
    IncDecByte(Weekday, change, 6);
    VE_DrawStringAt_b(-100, 0, c_WeekdayArr[Weekday], 80);
    SetRTCdate;
    DS_SetDate(Weekday, Day, Month, Year);
    |
  s_day:
    IncDecByte(Day, change, c_daypermonthArr[Month]);
     VE_DrawStringAt_b(-100, 0,'DAY: ' + ByteToStr(Day), 80);
    SetRTCdate;
    DS_SetDate(Weekday, Day, Month, Year);
    |
  s_month:
    IncDecByte(Month, change, 12);
    VE_DrawStringAt_b(-100, 0,'MONTH: ' + ByteToStr(Month), 80);
    SetRTCdate;
    DS_SetDate(Weekday, Day, Month, Year);
    |
  s_year:
    IncDecByte(Year, change, 99);
    VE_DrawStringAt_b(-100, 0,'YEAR: ' + ByteToStr(Year), 80);
    SetRTCdate;
    DS_SetDate(Weekday, Day, Month, Year);
    |
  s_daysleft:
    DestDayCount:= EE_DestDayCount; // ab 1.1.2000
    DaysLeft:= DestDayCount - CalcDays(Day, Month, Year);
    IncDecInt(DaysLeft, change, 9999);
    DestDayCount:= CalcDays(Day, Month, Year) + DaysLeft;
    EE_DestDayCount:= DestDayCount;
    VE_DrawStringAt_b(-100, 0,'DAYS LEFT: ' + IntToStr(DaysLeft), 80);
    |
  endcase;
  VE_UploadVals(ve_stopwait, 0, 0);
  VE_Run(0);
end;


procedure HandleScopeClock;
// Bei Bedarf (Semaphore gesetzt) Teile des Vector-RAMs überschreiben
begin
  if BoardMode <> board_asteroids then
    return;
  endif;
  if length(SerInpStr) > 0 then
    return;  // Updates und serielle Ausgabe verhindern
  endif;

  if InvertZ then
    InvertZ_Mask:= $0002;
  else
    InvertZ_Mask:= 0;
  endif;

  repeat
    // Buttons (Bit-Nr.) ButtonPort_0:
    // 0-Fire, 1=Rturn, 2=Coin, 3=Lturn, 4=Thrust, 5=Start, 6=Shield
    // Buttons (Bit-Nr.) ButtonPort_1:
    // 0-DEC, 1-INC, 2-Set H, M, S, Weekday, Day, Month, Year, DaysLeft, Run
    // 3-END SetMode
    if GetButtonPort then
      if ButtonPort_0 <> 0 then
        SPI_LoaderCmd(lc_port0, InvertZ_Mask or 0); // Asteroids aktiv
        ActiveCounter:= 20;
        State:= s_asteroids;
      endif;
    endif;
    // Buttons an Asteroids übermitteln
    if State = s_asteroids then
      SPI_LoaderCmd(lc_port1, Integer(ButtonPort_0)); // LSB
      if ButtonPort_1 <> 0 then
        ActiveCounter:= 0;
        State:= s_initclock;
        write(SerOut,'/ End Game');
        SerCRLF;
        SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Clock aktiv
      endif;
    endif;

    // Test für Animation
    if Bit(ButtonPort_1, 4) then
      State:= s_anim_1;
      WaitButtonRelease;
    endif;
    if Bit(ButtonPort_1, 5) then
      State:= s_anim_2;
      WaitButtonRelease;
    endif;

    if Bit(ButtonPort_1, 2) then
      IncToLimWrap(SetMode, s_second, s_run);
      SetItemVal(SetMode, 0);
      State:= s_initclock;
      WaitButtonRelease;
    endif;
    if (SetMode <> s_run) then
      if Bit(ButtonPort_1, 0) then
        SetItemVal(SetMode, -1);
        WaitButtonRelease;
      endif;
      if Bit(ButtonPort_1, 1) then
        SetItemVal(SetMode, 1);
        WaitButtonRelease;
      endif;
      if Bit(ButtonPort_1, 3) then
        SetMode:= s_run;
        State:= s_initclock;
        write(SerOut,'/ SetMode End');
        SerCRLF;
      endif;
    endif;
    if Bit(ButtonPort_1, 2) then
      IncToLimWrap(SetMode, s_daysleft, s_run);
      WaitButtonRelease;
    endif;
    mdelay(1);
  until SysTickSema;

  SysTickSema:= false;
  RandomInt:= Integer(Random and $7FFF);

  ShootFlareActive:= Shoot.visible or Flare.visible;
  UfoActive:= Ufo.visible or ShootFlareActive;

  Inc(Sec100);
  if SecondSema then
    Sec100:= 0;
  endif;

  case State of
  s_initclock:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Clock aktiv
    if DS_present then
      DS_GetTime(Second, Minute, Hour);
      SetRTCtime;
    else
      GetRTCtime;
    endif;
    Sec100:= 0;
    Pendulum.rotation:= 401;
    Shoot.visible:= false;
    if SetMode = s_run then
      VE_Stop;
      CreateClock;
      ActiveCounter:= 15;
      State:= s_updateclock;
    endif;
    UpdateSecondsHand;
    UpdateMinutesHand;
    UpdateHoursHand;
    |
  s_updateclock:
    UpdatePendulum;
    UpdateUfoAnimation;
    UpdateDamage;

    if SecondSema then
      SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Clock aktiv
      if DS_present then
        DS_GetTime(Second, Minute, Hour);
        SetRTCtime;
      else
        GetRTCtime;
      endif;
      Sec100:= 0;
      Pendulum.rotation:= 401;
      UpdateSecondsHand;
      UpdateMinutesHand;
      if not dectoLim(ActiveCounter, 0) then
        if not UfoActive then
          // Kein Ufo aktiv, Umschalten
          State:= s_anim;
        endif;
      endif;
      if ((Second mod 5) = 0) and ((RandomInt and 3) = 0)
      and (not UfoActive) then
        Ufo.trigger:= true;
      endif;
    endif;

    if MinuteSema then
      if (Minute mod 5) = 0 then
        RestoreDamage;
      endif;
      UpdateSecondsHand;
      UpdateMinutesHand;
      UpdateHoursHand;
    endif;

    if HourSema then
      DS_GetDate(Weekday, Day, Month, Year);
      if Weekday > 6 then
        Weekday:= 0;
        DS_SetDate(Weekday, Day, Month, Year);
        SetRTCdate;
      endif;
      DaysLeft:= DestDayCount - CalcDays(Day, Month, Year);
      UpdateHoursHand;
      UpdateDateString;
      UpdateWeekday;
    endif;
    |
  s_anim:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Animation 1 aktiv
    case AnimationNr of
    0:
      SplashScreen;
      |
    1:
      SplashSequence1;
      |
    2:
      SplashSequence2;
      |
    3:
      SplashSequence3;
      |
    endcase;
    Shoot.visible:= false;
    inctolimwrap(AnimationNr, 3, 0);
    State:= s_initasteroids;
    |
  s_anim_1:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Animation 1 aktiv
    SplashSequence1;
    State:= s_initclock;
    |
  s_anim_2:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Animation 1 aktiv
    SplashSequence2;
    State:= s_initclock;
    |
  s_anim_3:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Animation 1 aktiv
    SplashSequence3;
    State:= s_initclock;
    |
  s_msgscreen:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 1); // Animation 1 aktiv
    SplashScreen;
    State:= s_initclock;
    |
  s_initasteroids:
    SPI_LoaderCmd(lc_port0, InvertZ_Mask or 0); // Asteroids aktiv
    ActiveCounter:= 5;
    State:= s_asteroids;
    |
  s_asteroids:
    if SecondSema then
      if (not dectoLim(ActiveCounter, 0)) then
        State:= s_initclock;
      endif;
    endif;
    |
  s_stationaryscreen:
    repeat
    until CheckSer;
    |
  endcase;

  SecondSema:= false;
  MinuteSema:= false;
  HourSema:= false;

  //LED:= Bit(Second, 0);
end;

end scope_clock.

