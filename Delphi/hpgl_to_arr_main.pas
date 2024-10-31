unit hpgl_to_arr_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids,
  Vcl.Samples.Spin, Vcl.ComCtrls, CPort, CPortCtl, Vcl.Buttons,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ButtonOpenHPGL: TButton;
    DrawingBox: TPaintBox;
    OpenDialog1: TOpenDialog;
    SgBlocks: TStringGrid;
    StaticText1: TStaticText;
    TrackBarScale: TTrackBar;
    LabelMax: TLabel;
    LabelMin: TLabel;
    ButtonExportArrayData: TButton;
    SaveDialog1: TSaveDialog;
    ButtonExportVectorFile: TButton;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    LabelVectorsWritten: TLabel;
    StaticText6: TStaticText;
    BtnSettings: TBitBtn;
    ComPort1: TComPort;
    Timer1: TTimer;
    BtnSend: TBitBtn;
    ButtonOpenVec: TButton;
    PopupMenu1: TPopupMenu;
    PopupDeleteRow: TMenuItem;
    PopupInsertRow: TMenuItem;
    N1: TMenuItem;
    InsertRowSpeed1: TMenuItem;
    InsertBlankRow1: TMenuItem;
    FindNextMove1: TMenuItem;
    SgPens: TStringGrid;
    StaticText7: TStaticText;
    BtnReprocess: TBitBtn;
    SgFiles: TStringGrid;
    StaticText2: TStaticText;
    SgObjects: TStringGrid;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    ProgressBar1: TProgressBar;
    CheckBoxUsePencolors: TCheckBox;
    ClearTable1: TMenuItem;
    N4: TMenuItem;
    StaticText10: TStaticText;
    PopupMenu2: TPopupMenu;
    MenuItem8: TMenuItem;
    N3: TMenuItem;
    SelectObject1: TMenuItem;
    N6: TMenuItem;
    InsertRowBeamforallObjects2: TMenuItem;
    DeleteInitRowsforthisObject2: TMenuItem;
    StaticText11: TStaticText;
    CheckBoxReplaceSkip: TCheckBox;
    BtnSendReset: TBitBtn;
    EditBeam: TEdit;
    EditSpeed: TEdit;
    ApplyBeamandSpeedValuestoselectedObjects1: TMenuItem;
    BtnSendFPGA: TBitBtn;
    BtnSendBitmap: TBitBtn;
    PaintBox1: TPaintBox;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure ButtonOpenHPGLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawingBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBarScaleChange(Sender: TObject);
    procedure ButtonExportArrayDataClick(Sender: TObject);
    procedure SgBlocksSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ButtonExportVectorFileClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnSettingsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
    procedure BtnAddInitClick(Sender: TObject);
    procedure ButtonOpenVecClick(Sender: TObject);
    procedure SgBlocksMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupDeleteRowClick(Sender: TObject);
    procedure PopupInsertRowBeamClick(Sender: TObject);
    procedure InsertRowSpeed1Click(Sender: TObject);
    procedure InsertBlankRow1Click(Sender: TObject);
    procedure FindNextMove1Click(Sender: TObject);
    procedure SgBlocksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SgBlocksExit(Sender: TObject);
    procedure DrawingBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawingBoxMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SgBlocksDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SgPensDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure BtnReprocessClick(Sender: TObject);
    procedure BtnClearTableClick(Sender: TObject);
    procedure SgObjectsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SgObjectsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnAddInitToSelectedClick(Sender: TObject);
    procedure BtnApplyToObjectClick(Sender: TObject);
    procedure BtnApplyToAllClick(Sender: TObject);
    procedure SgObjectsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InsertRowBeamforallSelectedClick(Sender: TObject);
    procedure DeleteInitRowsforSelectedClick(Sender: TObject);
    procedure BtnSendResetClick(Sender: TObject);
    procedure SgObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnSendFPGAClick(Sender: TObject);
    procedure BtnSendBitmapClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure RefreshTable;
    procedure RefreshBitmap;
    procedure HighlightEntry;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Type
  t_ansitext = File of AnsiChar;

  t_hpgl_file = Record
    minX: Integer;
    minY: Integer;
    maxX: Integer;
    maxY: Integer;
    midX: Integer;
    midY: Integer;
    sizeX: Integer;
    sizeY: Integer;
    scale: Integer;
    startRow, endRow: Integer;
    objectCount: Integer;
  end;

var
  HPGL_bitmap: Tbitmap;
  BitmapOffsX, BitmapOffsY: Integer;
  ScrollStartX, ScrollStartY: Integer;
  ScrollOffsX, ScrollOffsY: Integer;
  IniPath: String;
  SectionStartRow, SectionEndRow: Integer;
  ValidSection: Boolean;
  SelectedRow: Integer;

  // HPGLfiles: Array[0..15] of t_hpgl_object;
  HPGLinfo: t_hpgl_file;
  HPGLfileNumber, HPGLfileCount: Integer;

  // #############################################################################

procedure get_element(var fh: t_ansitext; var element: AnsiString;
  var is_cmd: Boolean);
// Einzelnes Element extrahieren, Command oder Zahl
var
  ch: AnsiChar;
  is_number, is_delim: Boolean;
begin
  element:= '';
  is_number:= false;
  is_cmd:= false;
  is_delim:= false;
  repeat
    Read(fh, ch);
    if (ch >= #45) and (ch <= #57) then
    begin // "-", 0..9
      is_number:= true;
      if is_cmd then
        break;
      element:= element + ch;
    end;
    if (ch >= #65) and (ch <= #90) then
    begin // A..Z
      is_cmd:= true;
      if is_number then
        break;
      element:= element + ch;
    end;
    if (ch = ',') or (ch = ';') or (ch = #32) or (ch = #13) then
      is_delim:= true;
  until is_delim or Eof(fh);
  // Typ hat sich geändert, einen Schritt zurück
  if is_number and is_cmd then
    Seek(fh, Filepos(fh) - 1)
  else if is_delim and (not Eof(fh)) then
  begin
    repeat
      Read(fh, ch);
    until (ch > #32) or Eof(fh);
    Seek(fh, Filepos(fh) - 1);
  end;
end;

procedure HPGLfileLoad(filename: String; new_entry: Boolean);
// Liest File in FileBuffer und liefert Länge zurück
var
  HPGLfile: t_ansitext;
  my_row, X, Y, start_row: Integer;
  element: AnsiString;
  is_cmd, pen_up, pen_down, select_pen: Boolean;

begin
  if not FileExists(filename) then
    exit;
  FileMode:= fmOpenRead;
  System.AssignFile(HPGLfile, filename);
  System.Reset(HPGLfile);
  HPGLinfo.minX:= 9999;
  HPGLinfo.minY:= 9999;
  HPGLinfo.maxX:= -9999;
  HPGLinfo.maxY:= -9999;
  HPGLinfo.objectCount:= 0;
  pen_up:= false;
  pen_down:= false;
  select_pen:= false;

  with Form1 do
  begin
    for my_row:= 1 to SgPens.RowCount - 1 do
      SgPens.Cells[2, my_row]:= '';
    my_row:= SgBlocks.RowCount - 1;
    start_row:= my_row;
    while not Eof(HPGLfile) do
    begin
      repeat
        get_element(HPGLfile, element, is_cmd);
        if is_cmd then
        begin
          if element = 'PU' then
          begin
            pen_down:= false;
            pen_up:= true;
            select_pen:= false;
          end
          else if element = 'PD' then
          begin
            pen_down:= true;
            pen_up:= false;
            select_pen:= false;
          end
          else if CheckBoxUsePencolors.Checked and (element = 'SP') then
          begin
            pen_down:= false;
            pen_up:= false;
            select_pen:= true;
          end
          else
          begin
            pen_down:= false;
            pen_up:= false;
            select_pen:= false;
          end;
        end;
      until (not is_cmd) or Eof(HPGLfile);

      if (not is_cmd) then begin
        if select_pen then begin
          // Element ist eine Zahl, letztes Command PU oder PD
          SgBlocks.Cells[1, my_row]:= 'Beam';
          Y:= StrToIntDef(element, 1);
          X:= StrToIntDef(SgPens.Cells[1, Y + 1], 8);
          SgBlocks.Cells[2, my_row]:= '';
          SgBlocks.Cells[3, my_row]:= '';
          SgBlocks.Cells[4, my_row]:= IntToStr(X);
          SgBlocks.Cells[5, my_row]:= '0';
          SgBlocks.RowCount:= SgBlocks.RowCount + 1;
          SgPens.Cells[2, Y + 1]:= 'X';
          inc(my_row);
        end;
        if pen_down or pen_up then begin
          // Element ist eine Zahl, letztes Command PU oder PD
          if pen_down then
            SgBlocks.Cells[1, my_row]:= 'Line'
          else
            SgBlocks.Cells[1, my_row]:= 'Move';

          X:= StrToIntDef(element, 0);
          SgBlocks.Cells[2, my_row]:= element;
          // nächstes Element ist Y-Wert
          get_element(HPGLfile, element, is_cmd);
          SgBlocks.Cells[3, my_row]:= element;
          Y:= StrToIntDef(element, 0);
          if pen_down then
          begin
            if (X < HPGLinfo.minX) then
              HPGLinfo.minX:= X;
            if (Y < HPGLinfo.minY) then
              HPGLinfo.minY:= Y;
            if (X > HPGLinfo.maxX) then
              HPGLinfo.maxX:= X;
            if (Y > HPGLinfo.maxY) then
              HPGLinfo.maxY:= Y;
          end;
          SgBlocks.RowCount:= SgBlocks.RowCount + 1;
          inc(my_row);
        end;
      end;
    end;
    // letztes PU oder SP ist unnötig
    if (SgBlocks.Cells[1, my_row - 1] = 'Move') or
      (SgBlocks.Cells[1, my_row - 1] = 'Beam') then
      SgBlocks.RowCount:= SgBlocks.RowCount - 2
    else
      SgBlocks.RowCount:= SgBlocks.RowCount - 1;
    HPGLinfo.midX:= (HPGLinfo.maxX + HPGLinfo.minX) div 2;
    HPGLinfo.midY:= (HPGLinfo.maxY + HPGLinfo.minY) div 2;
    HPGLinfo.sizeX:= HPGLinfo.maxX - HPGLinfo.minX;
    HPGLinfo.sizeY:= HPGLinfo.maxY - HPGLinfo.minY;
    if HPGLinfo.sizeX >= HPGLinfo.sizeY then
      HPGLinfo.scale:= 250000 div HPGLinfo.sizeX
    else
      HPGLinfo.scale:= 250000 div HPGLinfo.sizeY;
    if new_entry then
    begin
      inc(HPGLfileCount);
      SgFiles.RowCount:= HPGLfileCount + 2;
      SgFiles.Cells[0, HPGLfileCount]:= IntToStr(HPGLfileCount);
      SgFiles.Cells[1, HPGLfileCount]:= IntToStr(start_row);
      SgFiles.Cells[2, HPGLfileCount]:= IntToStr(SgBlocks.RowCount - 1);
      SgFiles.Cells[3, HPGLfileCount]:= ExtractFileName(filename);
    end;
  end;
  CloseFile(HPGLfile);
end;

// #############################################################################
// #############################################################################

procedure DeleteRows(sg: TStringGrid; ARow, count: Integer);
var
  i: Integer;
begin
  with sg do
  begin
    for i:= ARow to RowCount - 2 do
      Rows[i].Assign(Rows[i + count]);
    RowCount:= RowCount - count;
  end;
end;

procedure InsertRows(sg: TStringGrid; ARow, count: Integer);
var
  i: Integer;
begin
  with sg do
  begin
    RowCount:= RowCount + count;
    for i:= RowCount - 1 downto ARow + count do
      Rows[i].Assign(Rows[i - count]);
    for i:= 1 to ColCount - 1 do
      Cells[i, ARow]:= '';
  end;
end;

// #############################################################################

procedure AddInitCmds(start_row: Integer; do_insert: Boolean);
var
  my_row: Integer;
begin
  with Form1.SgBlocks do
  begin
    if do_insert then begin
      if Cells[1, start_row - 1] = 'Skip' then begin
        InsertRows(Form1.SgBlocks, start_row, 6); // SKIP belassen
        dec(start_row);
      end else begin
        InsertRows(Form1.SgBlocks, start_row, 7); // komplett neu anlegen
        Cells[1, start_row]:= 'Skip';
        Cells[4, start_row]:= '0';
      end;
    end else begin
      Cells[1, start_row]:= 'Skip';
      Cells[4, start_row]:= '0';
    end;
    Cells[5, start_row]:= '0';
    Cells[1, start_row + 1]:= 'Beam';
    Cells[4, start_row + 1]:= Form1.EditBeam.Text;
    Cells[5, start_row + 1]:= '0';
    Cells[1, start_row + 2]:= 'Scale';
    Cells[4, start_row + 2]:= '1024';
    Cells[5, start_row + 2]:= '1024';
    Cells[1, start_row + 3]:= 'Offs';
    Cells[4, start_row + 3]:= '0';
    Cells[5, start_row + 3]:= '0';
    Cells[1, start_row + 4]:= 'Rot';
    Cells[4, start_row + 4]:= '0';
    Cells[5, start_row + 4]:= '0';
    Cells[1, start_row + 5]:= 'Center';
    Cells[4, start_row + 5]:= '0';
    Cells[5, start_row + 5]:= '0';
    Cells[1, start_row + 6]:= 'Speed';
    Cells[4, start_row + 6]:= Form1.EditSpeed.Text;
    Cells[5, start_row + 6]:= '0';
    for my_row:= start_row to start_row + 6 do begin
      Cells[2, my_row]:= '';
      Cells[3, my_row]:= '';
    end;
  end;
end;

procedure RenumberSg;
var
  my_row1, my_row2: Integer;
begin
  with Form1.SgBlocks do
    for my_row1:= RowCount - 1 downto 1 do begin
      Cells[0, my_row1]:= IntToStr(my_row1);
      // add Address-Links to SKIP
      if (Cells[1, my_row1] = 'Skip') and (my_row1 < RowCount - 2) then begin
        for my_row2:= my_row1 + 1 to RowCount-1 do
          if (Cells[1, my_row2] = 'Skip') then
            break;
        Cells[4, my_row1]:= IntToStr(my_row2 - my_row1);
      end;
    end;
end;

// #############################################################################

procedure CreateObjects(set_new_center: Boolean);
var
  my_row, my_obj, start_row, save_row, save_toprow: Integer;
  X, Y, xmin, ymin, xmax, ymax: Integer;
begin
  with Form1 do begin
    save_row:= SgObjects.Row;
    save_toprow:= SgObjects.TopRow;
   // save_row:= SgBlocks.Row;
   // save_toprow:= SgBlocks.TopRow;
    SgObjects.RowCount:= 2;
    SgObjects.Row:= 1;
    SgObjects.Cells[0, 0]:= '#';
    SgObjects.Cells[1, 0]:= 'Start';
    SgObjects.Cells[2, 0]:= 'End';
    SgObjects.Cells[3, 0]:= 'Xmin';
    SgObjects.Cells[4, 0]:= 'Ymin';
    SgObjects.Cells[5, 0]:= 'Xmax';
    SgObjects.Cells[6, 0]:= 'Ymax';
    HPGLinfo.objectCount:= 0;
    my_row:= 0;
    repeat
      inc(my_row);
      X:= StrToInt(SgBlocks.Cells[4, my_row]);
      Y:= StrToInt(SgBlocks.Cells[5, my_row]);
      if (SgBlocks.Cells[1, my_row] = 'Move') then begin
        // Neues Object beginnt mit MOVE
        inc(HPGLinfo.objectCount);
        SgObjects.RowCount:= HPGLinfo.objectCount + 2;
        SgObjects.Cells[0, HPGLinfo.objectCount]:= IntToStr(HPGLinfo.objectCount);
        if (my_row > 7) and (SgBlocks.Cells[1, my_row - 7] = 'Skip') then
          SgObjects.Cells[1, HPGLinfo.objectCount]:= IntToStr(my_row - 7)
        else
          SgObjects.Cells[1, HPGLinfo.objectCount]:= IntToStr(my_row);
        repeat
          inc(my_row);
        until (SgBlocks.Cells[1, my_row] = 'Move')
        or (SgBlocks.Cells[1, my_row] = 'Skip')
        or (my_row >= SgBlocks.RowCount - 2);
        dec(my_row);
        SgObjects.Cells[2, HPGLinfo.objectCount]:= IntToStr(my_row);
      end;
    until (my_row >= SgBlocks.RowCount - 1);

    if SgObjects.RowCount > 2 then begin
      SgObjects.Cells[0, HPGLinfo.objectCount]:= IntToStr(HPGLinfo.objectCount);
      SgObjects.Cells[2, HPGLinfo.objectCount]:= IntToStr(SgBlocks.RowCount - 1);
      SgObjects.RowCount:= SgObjects.RowCount - 1;
      // Größe der Objekte bestimmen
      for my_obj:= 1 to SgObjects.RowCount - 1 do begin
        xmin:= 9999;
        ymin:= 9999;
        xmax:= -9999;
        ymax:= -9999;
        for my_row:= StrToInt(SgObjects.Cells[1, my_obj]) to StrToInt(SgObjects.Cells[2, my_obj]) do
          if (SgBlocks.Cells[1, my_row] = 'Move')
          or (SgBlocks.Cells[1, my_row] = 'Line') then begin
            X:= StrToInt(SgBlocks.Cells[4, my_row]);
            Y:= StrToInt(SgBlocks.Cells[5, my_row]);
            if X <= xmin then
              xmin:= X;
            if Y <= ymin then
              ymin:= Y;
            if X >= xmax then
              xmax:= X;
            if Y >= ymax then
              ymax:= Y;
          end;
        SgObjects.Cells[3, my_obj]:= IntToStr(xmin);
        SgObjects.Cells[4, my_obj]:= IntToStr(ymin);
        SgObjects.Cells[5, my_obj]:= IntToStr(xmax);
        SgObjects.Cells[6, my_obj]:= IntToStr(ymax);
        my_row:= StrToInt(SgObjects.Cells[1, my_obj]);

        if set_new_center and (my_row + 7 < SgBlocks.RowCount)
        and (SgBlocks.Cells[1, my_row+5] = 'Center') then begin
          SgBlocks.Cells[4, my_row+5]:= IntToStr((xmax + xmin) div 2);
          SgBlocks.Cells[5, my_row+5]:= IntToStr((ymax + ymin) div 2);
        end;
      end;
    end;
    if save_row < SgObjects.RowCount then begin
      SgObjects.Row:= save_row;
      SgObjects.TopRow:= save_toprow;
    end;
  end;
end;

function GetRowSection(var start_row, end_row: Integer): Boolean;
var
  obj_row, first_row, last_row: Integer;
begin
  result:= false;
  with Form1.SgObjects do
    for obj_row:= 1 to RowCount - 1 do begin
      first_row:= StrToIntDef(Cells[1, obj_row], 1);
      last_row:= StrToIntDef(Cells[2, obj_row], 1);
      if (start_row >= first_row) and (start_row <= last_row) then
      begin
        start_row:= first_row;
        end_row:= last_row;
        result:= true;
        break;
      end;
    end;
end;

// #############################################################################


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
// 11 - Dummy Cycle, NOP
// 10 - Pause, X-Wert * 5µs
// 12 - Stop, warte auf Reset
// 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
// 14 - Aufruf Subroutine an Adresse X
// 15 - Return aus Subroutine
// 16 - Setze Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Setze Deflection Timer 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Setze XY Point
// 19 - Skip, Jump relativ
const
  c_move: LongInt = $00000000;
  c_line: LongInt = $00002000;
  c_beam: LongInt = $10000000;
  c_pause: LongInt = $0000A000; // 20*5 = 100µs Schwarzschulter
  c_nop: LongInt = $0000B000;
  c_scale0: LongInt = $00009000;
  c_offs0: LongInt = $00006000;
  c_rotmid: LongInt = $00007000;
  c_rot0: LongInt = $00008000;
  c_stopwait: LongInt = $0000C000;
  c_jump: LongInt = $0000D000;
  c_defltime: LongInt = $10001000;
  c_skip: LongInt = $10003000;

function RowToVec(my_row: Integer): LongWord;
// liefert Vektor aus Stringgrid-Eintrag
// Vector Data (LV_INC = 1):
// 31 (3) 24   23 (2) 16   15 (1)  8   7  (0)  0       (In Klammern: Byte von MCU-IF)
// CCCC YYYY   YYYY YYYY   CCCC XXXX   XXXX XXXX
// C = Command, LSB in 15:12, MSB in 31:24
// Y = Y-Wert oder Kreisabschnitt-Ende,
// X = X-Wert, Kreis-Radius, Kreisabschnitt-Start oder Adresse

var
  x_str, y_str, cmd_str: String;
  x_val, y_val, xy_val: LongInt;
  vec: LongWord;
begin
  vec:= 0;
  with Form1.SgBlocks do begin
    x_str:= Cells[4, my_row];
    y_str:= Cells[5, my_row];
    x_val:= StrToInt(x_str) and $FFF;
    y_val:= (StrToInt(y_str) shl 16) and $0FFF0000;
    xy_val:= x_val or y_val;
    cmd_str:= Cells[1, my_row];
    if cmd_str = 'Move' then
      vec:= xy_val or c_move
    else if cmd_str = 'Line' then
      vec:= xy_val or c_line
    else if cmd_str = 'Beam' then
      vec:= xy_val or c_beam
    else if cmd_str = 'Scale' then
      vec:= xy_val or c_scale0
    else if cmd_str = 'Offs' then
      vec:= xy_val or c_offs0
    else if cmd_str = 'Pause' then
      vec:= x_val or c_pause
    else if cmd_str = 'NOP' then
      vec:= c_nop
    else if cmd_str = 'Skip' then
      vec:= xy_val or c_skip // Wird beim Laden der Datei erst auf NOP gesetzt
    else if cmd_str = 'Rot' then begin
      x_val:= (StrToInt(Cells[4, my_row]) * 804 div 360) and $FFF;
      vec:= x_val or c_rot0
    end else if cmd_str = 'Center' then
      vec:= xy_val or c_rotmid
    else if cmd_str = 'Speed' then
      vec:= x_val or c_defltime
    else if cmd_str = 'Jump' then
      vec:= x_val or c_jump
    else if cmd_str = 'Wait' then
      vec:= x_val or c_stopwait;
  end;
  result:= vec;
end;

procedure VecToRow(my_row: Integer; vec: LongWord);
// wnadelt Vektor in Stringgrid-Eintrag
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
// 11 - Dummy Cycle, NOP
// 12 - Stop, warte auf Reset
// 13 - Jump/Loop, Ende der Vektoren, Start wieder mit Adresse X
// 14 - Aufruf Subroutine an Adresse X
// 15 - Return aus Subroutine
// 16 - Setze Beam Intenity 0..7 (in X-Wert) für alle folgenden Draw-Funktionen
// 17 - Setze Deflection Timer 0..4095 (Vektor-Schreibgeschwindigkeit)
// 18 - Setze XY Point
// 19 - Skip, Jump relativ

var
  x_str, y_str, cmd_str: String;
  x_val, y_val, rot: LongInt;
  vec_mask: LongWord;
begin
  x_val:= vec and $FFF;
  if x_val and $800 = $800 then
    x_val:= -(x_val xor $FFF);
  y_val:= (vec shr 16) and $FFF;
  if y_val and $800 = $800 then
    y_val:= -(y_val xor $FFF);
  rot:= x_val * 360 div 804;

  if (x_val < HPGLinfo.minX) then
    HPGLinfo.minX:= x_val;
  if (y_val < HPGLinfo.minY) then
    HPGLinfo.minY:= y_val;
  if (x_val > HPGLinfo.maxX) then
    HPGLinfo.maxX:= x_val;
  if (y_val > HPGLinfo.maxY) then
    HPGLinfo.maxY:= y_val;

  x_str:= IntToStr(x_val);
  y_str:= IntToStr(y_val);

  vec_mask:= vec and $F000F000;
  cmd_str:= '';
  with Form1.SgBlocks do begin
    Cells[2, my_row]:= '';
    Cells[3, my_row]:= '';
    Cells[4, my_row]:= x_str;
    Cells[5, my_row]:= y_str;
    if vec_mask = c_move then begin
      cmd_str:= 'Move';
      Cells[2, my_row]:= x_str;
      Cells[3, my_row]:= y_str;
    end else if vec_mask = c_line then begin
      cmd_str:= 'Line';
      Cells[2, my_row]:= x_str;
      Cells[3, my_row]:= y_str;
    end else if vec_mask = c_beam then
      cmd_str:= 'Beam'
    else if (vec_mask = c_nop) or (vec_mask = c_skip) then begin
      cmd_str:= 'Skip';
      Cells[2, my_row]:= x_str;
      Cells[3, my_row]:= y_str;
    end else if vec_mask = c_scale0 then
      cmd_str:= 'Scale'
    else if vec_mask = c_offs0 then
      cmd_str:= 'Offs'
    else if vec_mask = c_rot0 then begin
      cmd_str:= 'Rot';
      Cells[4, my_row]:= IntToStr(rot);
    end else if vec_mask = c_rotmid then
      cmd_str:= 'Center'
    else if vec_mask = c_defltime then
      cmd_str:= 'Speed'
    else if vec_mask = c_jump then
      cmd_str:= 'Jump'
    else if vec_mask = c_pause then
      cmd_str:= 'Pause'
    else if vec_mask = c_stopwait then
      cmd_str:= 'Wait';

    Cells[1, my_row]:= cmd_str;
  end;
end;

procedure TForm1.HighlightEntry;
var
  X, Y, xb, yb, scale: Integer;
begin
  with SgBlocks do begin
    if (Cells[1, SelectedRow] = 'Move') or (Cells[1, SelectedRow] = 'Line') then
    begin
      scale:= (TrackBarScale.Position * HPGLinfo.scale) div 50;
      X:= ((StrToIntDef(SgBlocks.Cells[2, SelectedRow], 0) - HPGLinfo.midX) *
        scale div 64) + (ScrollOffsX * 8);
      Y:= ((StrToIntDef(SgBlocks.Cells[3, SelectedRow], 0) - HPGLinfo.midY) *
        scale div 64) - (ScrollOffsY * 8);
      xb:= (X div 8) + BitmapOffsX;
      yb:= HPGL_bitmap.Height - (Y div 8) - BitmapOffsY;
      if SgBlocks.Cells[1, SelectedRow] = 'Move' then
        HPGL_bitmap.Canvas.Pen.Color:= clLime
      else
        HPGL_bitmap.Canvas.Pen.Color:= clred;
      HPGL_bitmap.Canvas.moveto(xb - 10, yb);
      HPGL_bitmap.Canvas.lineto(xb + 10, yb);
      HPGL_bitmap.Canvas.moveto(xb, yb - 10);
      HPGL_bitmap.Canvas.lineto(xb, yb + 10);
      DrawingBox.Canvas.Draw(0, 0, HPGL_bitmap);
    end;
  end;
end;

procedure TForm1.RefreshBitmap;
const
  c_colors: Array [0 .. 15] of TColor = (0, 0, 0, 0, 0, 0, 0, 0, $00404040,
    $00505050, $00606060, $00707070, $00909090, $00A0A0A0, $00D0D0D0,
    $00FFFFFF);
var
  my_row: Integer;
  xb, yb: Integer;
  my_color: TColor;
begin
  HPGL_bitmap.Canvas.Pen.Color:= clWebGreen;
  HPGL_bitmap.Canvas.Brush.Color:= $00003000; // Hintergrund dunkelgrün
  HPGL_bitmap.Canvas.FillRect(Rect(0, 0, HPGL_bitmap.Width,
    HPGL_bitmap.Height));
  HPGL_bitmap.Canvas.moveto(0, HPGL_bitmap.Height div 2);
  HPGL_bitmap.Canvas.lineto(HPGL_bitmap.Width, HPGL_bitmap.Height div 2);
  HPGL_bitmap.Canvas.moveto(HPGL_bitmap.Width div 2, 0);
  HPGL_bitmap.Canvas.lineto(HPGL_bitmap.Width div 2, HPGL_bitmap.Height);

  my_color:= c_colors[12];
  HPGL_bitmap.Canvas.Pen.Color:= my_color;
  with SgBlocks do
    for my_row:= 1 to RowCount - 1 do begin
      xb:= (StrToIntDef(Cells[4, my_row], 0) div 8) + BitmapOffsX;
      yb:= HPGL_bitmap.Height - (StrToIntDef(Cells[5, my_row], 0) div 8) -
        BitmapOffsY;
      if Cells[1, my_row] = 'Beam' then
      begin
        my_color:= c_colors[StrToInt(Cells[4, my_row])];
        HPGL_bitmap.Canvas.Pen.Color:= my_color;
      end
      else if SgBlocks.Cells[1, my_row] = 'Move' then
      begin
        HPGL_bitmap.Canvas.moveto(xb, yb);
      end
      else if SgBlocks.Cells[1, my_row] = 'Line' then
      begin
        if ValidSection and (my_row >= SectionStartRow) and
          (my_row <= SectionEndRow) then
          HPGL_bitmap.Canvas.Pen.Color:= clWebCyan
        else
          HPGL_bitmap.Canvas.Pen.Color:= my_color;
        HPGL_bitmap.Canvas.lineto(xb, yb);
      end;
    end;
  DrawingBox.Canvas.Draw(0, 0, HPGL_bitmap);
end;

procedure TForm1.RefreshTable;
var
  my_row: Integer;
  X, Y, scale: Integer;
  min_x, max_x, min_y, max_y: Integer;
begin
  min_x:= 9999;
  min_y:= 9999;
  max_x:= -9999;
  max_y:= -9999;
  scale:= (TrackBarScale.Position * HPGLinfo.scale) div 50;
  for my_row:= 1 to SgBlocks.RowCount - 1 do begin
    X:= ((StrToIntDef(SgBlocks.Cells[2, my_row], 0) - HPGLinfo.midX) *
      scale div 64) + (ScrollOffsX * 8);
    Y:= ((StrToIntDef(SgBlocks.Cells[3, my_row], 0) - HPGLinfo.midY) *
      scale div 64) - (ScrollOffsY * 8);
    with SgBlocks do begin
      if (Cells[1, my_row] = 'Move') or (Cells[1, my_row] = 'Line') then
      begin
        SgBlocks.Cells[4, my_row]:= IntToStr(X);
        SgBlocks.Cells[5, my_row]:= IntToStr(Y);
        if X < min_x then
          min_x:= X;
        if Y < min_y then
          min_y:= Y;
        if X > max_x then
          max_x:= X;
        if Y > max_y then
          max_y:= Y;
      end;
    end;
  end;
  LabelMin.Caption:= 'Min: ' + IntToStr(min_x) + ', ' + IntToStr(min_y);
  LabelMax.Caption:= 'Max: ' + IntToStr(max_x) + ', ' + IntToStr(max_y);
  LabelVectorsWritten.Caption:= 'Vectors: ' + IntToStr(SgBlocks.RowCount - 1);
end;

procedure TForm1.SgBlocksSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  SelectedRow:= ARow;
  SectionStartRow:= SelectedRow;
  SectionEndRow:= SgBlocks.RowCount - 1;
  ValidSection:= GetRowSection(SectionStartRow, SectionEndRow);

  RefreshBitmap;
  HighlightEntry;
  SgBlocks.Repaint;
end;

procedure TForm1.SgObjectsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow = 0) or (ACol = 0) then
    with SgObjects do begin
      Canvas.font.Style:= [fsBold];
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TForm1.SgObjectsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
  pt: TPoint;
  my_obj_startrow, my_obj_endrow: Integer;
begin
  if Button = mbRight then begin
    pt:= SgObjects.ClientToScreen(Point(X, Y));
    PopupMenu2.Popup(pt.X, pt.Y);
    //SgObjects.MouseToCell(X, Y, Col, Row);
    //SgObjects.Col:= Col;
    //SgObjects.Row:= Row;
  end;
  if (ssLeft in Shift) then begin
    my_obj_startrow:= SgObjects.Selection.Top;
    my_obj_endrow:= SgObjects.Selection.Bottom;
    SelectedRow:= StrToIntDef(SgObjects.Cells[1, my_obj_startrow], 1);
    if SelectedRow < SgBlocks.RowCount then begin
      SectionStartRow:= StrToIntDef(SgObjects.Cells[1, my_obj_startrow], 1);
      SectionEndRow:= StrToIntDef(SgObjects.Cells[2, my_obj_endrow], 1);
      if SelectedRow - 2 > 1 then
        SgBlocks.TopRow:= SelectedRow - 2;
      ValidSection:= true;
      SgBlocks.Row:= SelectedRow;
    end else
      ValidSection:= false;
    RefreshBitmap;
    HighlightEntry;
  end;
end;


procedure TForm1.SgObjectsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  my_obj_startrow, my_obj_endrow: Integer;
begin
  if (ssLeft in Shift) then begin
    my_obj_startrow:= SgObjects.Selection.Top;
    my_obj_endrow:= SgObjects.Selection.Bottom;
    SelectedRow:= StrToIntDef(SgObjects.Cells[1, my_obj_startrow], 1);
    if SgBlocks.RowCount > SelectedRow then begin
      SectionStartRow:= StrToIntDef(SgObjects.Cells[1, my_obj_startrow], 1);
      SectionEndRow:= StrToIntDef(SgObjects.Cells[2, my_obj_endrow], 1);
      if SelectedRow - 2 > 1 then
        SgBlocks.TopRow:= SelectedRow - 2;
      ValidSection:= true;
      SgBlocks.Row:= SelectedRow;
    end else
      ValidSection:= false;
    RefreshBitmap;
    HighlightEntry;
  end;
end;

procedure TForm1.SgObjectsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  my_obj_startrow, my_obj_endrow: Integer;
begin
  my_obj_startrow:= SgObjects.Selection.Top;
  my_obj_endrow:= SgObjects.Selection.Bottom;
  SelectedRow:= StrToIntDef(SgObjects.Cells[1, ARow], 1);
  if SgBlocks.RowCount > SelectedRow then begin
    SectionStartRow:= StrToIntDef(SgObjects.Cells[1, my_obj_startrow], 1);
    SectionEndRow:= StrToIntDef(SgObjects.Cells[2, my_obj_endrow], 1);
    if SelectedRow - 2 > 1 then
      SgBlocks.TopRow:= SelectedRow - 2;
    ValidSection:= true;
    SgBlocks.Row:= SelectedRow;
  end else
    ValidSection:= false;
  RefreshBitmap;
  HighlightEntry;
end;

procedure TForm1.SgPensDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ARow = 0) or (ACol = 0) then with SgPens do begin
    Canvas.font.Style:= [fsBold];
    Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
  end;
end;

procedure TForm1.BtnSendFPGAClick(Sender: TObject);
var
  my_byte: Integer;
  binfilestream: TFileStream;
  count, bytes_read: Integer;
  aByte: Byte;
begin
  ProgressBar1.Max:= 207;

  OpenDialog1.FilterIndex:= 3;
  OpenDialog1.DefaultExt:= '*.bit';
  OpenDialog1.Title:= 'Open BIT File):';
  count:= 0;
  if OpenDialog1.Execute then begin
    try
      binfilestream:= TFileStream.Create(OpenDialog1.filename, fmOpenRead);
      binfilestream.Position:= 0;
      ProgressBar1.Max:= binfilestream.Size div 256;
      ComPort1.WriteStr('190=' + IntToStr(binfilestream.Size) +  #13);
      Memo1.Lines.Add(#13 + 'Sending ' + IntToStr(binfilestream.Size) + ' Bytes...');
      sleep(20);
      repeat
        bytes_read:= binfilestream.Read(aByte, 1);
        if bytes_read > 0 then
          ComPort1.Write(aByte, 1);

        if count mod 256 = 0 then begin
          ProgressBar1.Position:= count div 256;
          Application.ProcessMessages;
          sleep(10);
        end;
        inc(count);
      until bytes_read = 0;
    finally
      binfilestream.Free;
    end;
  end;
  ProgressBar1.Position:= 0;
end;


procedure TForm1.BtnAddInitClick(Sender: TObject);
begin
  if SgBlocks.Cells[1, SgBlocks.Row] = 'Beam' then
    AddInitCmds(SgBlocks.Row + 1, true)
  else
    AddInitCmds(SgBlocks.Row, true);
  RenumberSg;
  RefreshTable;
  CreateObjects(true);
  SelectedRow:= SgBlocks.Row;
  RefreshBitmap;
end;

procedure TForm1.BtnAddInitToSelectedClick(Sender: TObject);
// Inser Init rows for selected Objects
var
  my_obj_row, my_block_row: Integer;
begin
  for my_obj_row:= SGObjects.Selection.Bottom downto SGObjects.Selection.Top do begin
     my_block_row:= StrToInt(SgObjects.Cells[1, my_obj_row]);
     AddInitCmds(my_block_row, true);
  end;
  RenumberSg;
  RefreshTable;
  CreateObjects(true);
  SelectedRow:= SgBlocks.Row;
  RefreshBitmap;
end;

procedure TForm1.BtnApplyToAllClick(Sender: TObject);
var
  my_obj_row, my_block_row: Integer;
begin
  for my_obj_row:= SGObjects.Selection.Bottom downto SGObjects.Selection.Top do begin
    my_block_row:= StrToInt(SgObjects.Cells[1, my_obj_row]);
    if (SgBlocks.Cells[1, my_block_row] = 'Move')
    and (SgBlocks.Cells[1, my_block_row - 1] = 'Beam') then
      SgBlocks.Cells[4, my_block_row - 1]:= EditBeam.Text;

    if (SgBlocks.Cells[1, my_block_row] = 'Skip') then
      SgBlocks.Cells[4, my_block_row + 1]:= EditBeam.Text;
  end;
  RefreshBitmap;
end;

procedure TForm1.InsertRowBeamforallSelectedClick(Sender: TObject);
// Inser BEAM row for selected Objects
var
  my_obj_row, my_block_row: Integer;
begin
  for my_obj_row:= SGObjects.Selection.Bottom downto SGObjects.Selection.Top do begin
    my_block_row:= StrToInt(SgObjects.Cells[1, my_obj_row]);
    if (SgBlocks.Cells[1, my_block_row] <> 'Beam') then begin
      InsertRows(SgBlocks, my_block_row, 1); // BEAM einsetzen
      SgBlocks.Cells[1, my_block_row]:= 'Beam';
      SgBlocks.Cells[4, my_block_row]:= EditBeam.Text;
      SgBlocks.Cells[5, my_block_row]:= '0';
    end;
  end;
  RenumberSg;
  RefreshTable;
  CreateObjects(false);
  RefreshBitmap;
end;

procedure TForm1.BtnApplyToObjectClick(Sender: TObject);
begin
  if (SgBlocks.Cells[1, SectionStartRow] = 'Beam')
  and (SgBlocks.Cells[1, SectionStartRow + 5] = 'Speed') then
    AddInitCmds(SectionStartRow, false);
  RefreshBitmap;
end;

procedure TForm1.DrawingBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  my_row: Integer;
  Col, Row: Integer;
  pt: TPoint;
begin
  DrawingBox.Tag:= 0;
  if (ssLeft in Shift) then begin
    ScrollStartX:= X;
    ScrollStartY:= Y;
  end;
  if (ssRight in Shift) and (SgObjects.RowCount > 2) then begin
    pt:= DrawingBox.ClientToScreen(Point(X, Y)); // für Popup
    X:= X * 8 - 2048;
    Y:= 2048 - Y * 8;
    for my_row:= 1 to SgObjects.RowCount - 1 do begin
      if (X >= StrToInt(SgObjects.Cells[3, my_row])) and
        (Y >= StrToInt(SgObjects.Cells[4, my_row])) and
        (X <= StrToInt(SgObjects.Cells[5, my_row])) and
        (Y <= StrToInt(SgObjects.Cells[6, my_row])) then
      begin
        SgObjects.Row:= my_row;
        break;
      end;
    end;
    Application.ProcessMessages;
    PopupMenu2.Popup(pt.X, pt.Y);
  end;
end;

procedure TForm1.DrawingBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (ssLeft in Shift) then begin
    ScrollOffsX:= X - ScrollStartX;
    ScrollOffsY:= Y - ScrollStartY;
    RefreshTable;
    RefreshBitmap;
    DrawingBox.Tag:= 1;
  end;
end;

procedure TForm1.DrawingBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if DrawingBox.Tag = 1 then
    CreateObjects(false);
  DrawingBox.Tag:= 0;
end;

procedure TForm1.ButtonExportArrayDataClick(Sender: TObject);
var
  idx, vec_count: Integer;
  sl: TStringlist;
  x_str, y_str, x_str_old, y_str_old, cmd_str: String;
  X, Y, x_old, y_old: Integer;
  is_move, is_line: Boolean;
begin
  x_old:= -9999;
  y_old:= -9999;
  vec_count:= 0;
  sl:= TStringlist.Create;
  sl.Add('  ');
  sl.Add('  xxx, xxx'); // Byte 0: Anzahl Vektoren LSB, Byte 1: MSB
  for idx:= 1 to SgBlocks.RowCount - 1 do begin
    x_str:= SgBlocks.Cells[4, idx];
    y_str:= SgBlocks.Cells[5, idx];
    X:= StrToInt(x_str) div 16;
    Y:= StrToInt(y_str) div 16;
    is_move:= SgBlocks.Cells[1, idx] = 'Move';
    is_line:= SgBlocks.Cells[1, idx] = 'Line';
    // Gleiche Zeilen überspringen
    if is_move or (is_line and ((X <> x_old) or (Y <> y_old))) then begin
      if is_move and (idx > 1) then begin
        sl.Add('  -128,-128,  // MoveTo, #' + IntToStr(vec_count));
        inc(vec_count);
      end;
      sl.Add('  ' + IntToStr(X) + ',' + IntToStr(Y) + ',  // #' +
        IntToStr(vec_count));
      inc(vec_count);
    end;
    x_old:= X;
    y_old:= Y;
  end;
  sl.Add('  -128,-128 ); // End, #' + IntToStr(vec_count));
  if (vec_count mod 256) < 128 then
    cmd_str:= IntToStr(vec_count mod 256)
  else
    cmd_str:= '-' + IntToStr(256 - (vec_count mod 256));
  sl[0]:= 'c_logo_arr: Array[0..' + IntToStr(vec_count * 2 + 3) +
    '] of Int8 = (';
  sl[1]:= ('  ' + cmd_str + ',' + IntToStr(vec_count div 256) +
    ', // Byte 0: Anzahl Vektoren LSB, Byte 1: MSB');
  Memo1.Lines.Clear;
  for idx:= 0 to sl.count - 1 do
    Memo1.Lines.Add(sl[idx]);
  SaveDialog1.FilterIndex:= 2;
  SaveDialog1.DefaultExt:= '*.txt';
  SaveDialog1.Title:= 'Save Include (TXT) File):';
  SaveDialog1.filename:= 'logo_vectors.txt';
  if SaveDialog1.Execute then
    sl.SaveToFile(SaveDialog1.filename);
  sl.Free;
end;

procedure TForm1.ButtonOpenHPGLClick(Sender: TObject);
var
  i: Integer;
  CanSelect: Boolean;
begin
  TrackBarScale.Position:= 50;
  OpenDialog1.FilterIndex:= 1;
  OpenDialog1.DefaultExt:= '*.hpgl';
  OpenDialog1.Title:= 'Open HPGL File):';
  if OpenDialog1.Execute then begin
    SaveDialog1.filename:= 'LOGO_xx.VEC';
    BtnClearTableClick(Sender);
    HPGLfileLoad(OpenDialog1.filename, true);
    RenumberSg;
    Application.ProcessMessages;
    ScrollOffsX:= 0;
    ScrollOffsY:= 0;
    RefreshTable;
    RefreshBitmap;
    BtnReprocess.Enabled:= true;
    CreateObjects(true);
    SgBlocksSelectCell(Sender, 1, 2, CanSelect);
  end;
  SgBlocks.FixedRows:= 1;
end;

procedure TForm1.ButtonOpenVecClick(Sender: TObject);
var
  binfilestream: TFileStream;
  my_row: Integer;
  vec: LongWord;
begin
  TrackBarScale.Position:= 50;
  OpenDialog1.FilterIndex:= 2;
  OpenDialog1.DefaultExt:= '*.vec';
  OpenDialog1.Title:= 'Open VEC File):';
  if OpenDialog1.Execute then begin
    SgBlocks.RowCount:= 2;
    SaveDialog1.filename:= OpenDialog1.filename;
    HPGLinfo.scale:= 64;
    HPGLinfo.minX:= 9999;
    HPGLinfo.minY:= 9999;
    HPGLinfo.maxX:= -9999;
    HPGLinfo.maxY:= -9999;
    try
      binfilestream:= TFileStream.Create(OpenDialog1.filename, fmOpenRead);
      binfilestream.Position:= 0;
      for my_row:= 1 to 2047 do begin
        if binfilestream.Read(vec, 4) = 0 then
          break;
        VecToRow(my_row, vec);
        SgBlocks.RowCount:= SgBlocks.RowCount + 1;
      end;
    finally
      binfilestream.Free;
    end;
    SgBlocks.RowCount:= SgBlocks.RowCount - 1;
    HPGLinfo.midX:= 0;
    HPGLinfo.midY:= 0;
    HPGLinfo.sizeX:= HPGLinfo.maxX - HPGLinfo.minX;
    HPGLinfo.sizeY:= HPGLinfo.maxY - HPGLinfo.minY;
    RenumberSg;
    Application.ProcessMessages;
    ScrollOffsX:= 0;
    ScrollOffsY:= 0;
    RefreshTable;
    RefreshBitmap;
    CreateObjects(false);
  end;
  SgBlocks.FixedRows:= 1;
end;

procedure TForm1.BtnSettingsClick(Sender: TObject);
begin
  ComPort1.ShowSetupDialog;
  ComPort1.StoreSettings(stIniFile, IniPath + 'HPGLconvert.ini');
  // ComPort1.StoreSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\HPGLconvert');
  ComPort1.Open;
end;

procedure TForm1.FindNextMove1Click(Sender: TObject);
var
  i: Integer;
begin
  if SgBlocks.Row < SgBlocks.RowCount - 2 then begin
    for i:= SgBlocks.Row+1 to SgBlocks.RowCount - 2 do
      if SgBlocks.Cells[1, i] = 'Move' then
        break;
    SgBlocks.Col:= 1;
    SgBlocks.Row:= i;
    SelectedRow:= i;
    if SelectedRow > 2 then
      SgBlocks.TopRow:= SelectedRow - 2;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  // ComPort1.LoadSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\HPGLconvert');
  ComPort1.LoadSettings(stIniFile, IniPath + 'HPGLconvert.ini');
  RefreshTable;
  RefreshBitmap;
  RenumberSg;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  IniPath:= ExtractFilePath(Application.ExeName);
  HPGL_bitmap:= Tbitmap.Create;
  HPGL_bitmap.Width:= DrawingBox.Width;
  HPGL_bitmap.Height:= DrawingBox.Height;
  BitmapOffsX:= DrawingBox.Width div 2;
  BitmapOffsY:= DrawingBox.Height div 2;
  OpenDialog1.filename:= '';
  BtnClearTableClick(Sender);
  SgPens.Cells[0, 0]:= 'Pen';
  SgPens.Cells[1, 0]:= 'Beam';
  SgPens.Cells[2, 0]:= 'Used';
  for i:= 1 to SgPens.RowCount - 1 do begin
    SgPens.Cells[0, i]:= IntToStr(i - 1);
    SgPens.Cells[1, i]:= '12';
    SgPens.Cells[2, i]:= '';
  end;
  SgPens.Cells[1, 1]:= '0';
  CreateObjects(true);
end;

procedure TForm1.PopupDeleteRowClick(Sender: TObject);
begin
  DeleteRows(SgBlocks, SgBlocks.Row, 1);
  RenumberSg;
  CreateObjects(false);
end;

procedure TForm1.DeleteInitRowsforSelectedClick(Sender: TObject);
// Delete INIT rows for selected Objects
var
  my_obj_row, my_block_row: Integer;
begin
  for my_obj_row:= SGObjects.Selection.Bottom downto SGObjects.Selection.Top do begin
    my_block_row:= StrToInt(SgObjects.Cells[1, my_obj_row]);
    if (SgBlocks.Cells[1, my_block_row] = 'Skip') then begin
      DeleteRows(SgBlocks, my_block_row, 7);
      RenumberSg;
      CreateObjects(false);
      RefreshBitmap;
    end;
  end;
end;


procedure TForm1.PopupInsertRowBeamClick(Sender: TObject);
begin
  InsertRows(SgBlocks, SgBlocks.Row, 1);
  SgBlocks.Cells[1, SgBlocks.Row]:= 'Beam';
  SgBlocks.Cells[4, SgBlocks.Row]:= '12';
  SgBlocks.Cells[5, SgBlocks.Row]:= '0';
  RenumberSg;
  CreateObjects(false);
  RefreshBitmap;
end;

procedure TForm1.InsertBlankRow1Click(Sender: TObject);
begin
  InsertRows(SgBlocks, SgBlocks.Row, 1);
  SgBlocks.Cells[1, SgBlocks.Row]:= 'Skip';
  SgBlocks.Cells[4, SgBlocks.Row]:= '0';
  SgBlocks.Cells[5, SgBlocks.Row]:= '0';
  RenumberSg;
  CreateObjects(false);
end;


procedure TForm1.InsertRowSpeed1Click(Sender: TObject);
begin
  InsertRows(SgBlocks, SgBlocks.Row, 1);
  SgBlocks.Cells[1, SgBlocks.Row]:= 'Speed';
  SgBlocks.Cells[4, SgBlocks.Row]:= '8';
  SgBlocks.Cells[5, SgBlocks.Row]:= '0';
  RenumberSg;
  CreateObjects(false);
end;

procedure TForm1.SgBlocksDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
// https://docwiki.embarcadero.com/RADStudio/Athens/en/Colors_in_the_VCL
begin
  if (ARow = 0) or (ACol = 0) then
    with SgBlocks do begin
      Canvas.font.Style:= [fsBold];
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);
    end
  else if (SelectedRow = ARow) then
    with SgBlocks do begin
      Canvas.Brush.Color:= clHighlight;
      Canvas.font.Color:= clHighlightText;
      Rect.Left:= Rect.Left - 4;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 6, Rect.Top + 2, Cells[ACol, ARow]);
    end
  else if (SgBlocks.Cells[1, ARow] = 'Skip') then
    with SgBlocks do begin
      Canvas.Brush.Color:= clWebPaleGoldenrod;
      Canvas.font.Color:= clwindowtext;
      Rect.Left:= Rect.Left - 4;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 6, Rect.Top + 2, Cells[ACol, ARow]);
    end
  else if (SgBlocks.Cells[1, ARow] = 'Move') then
    with SgBlocks do begin
      Canvas.Brush.Color:= clmoneygreen;
      Canvas.font.Color:= clwindowtext;
      Rect.Left:= Rect.Left - 4;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 6, Rect.Top + 2, Cells[ACol, ARow]);
    end
  else if (ARow >= SectionStartRow) and (ARow <= SectionEndRow) then
    with SgBlocks do begin
      if (Cells[1, ARow] = 'Line') or (Cells[1, ARow] = 'Move') then
        Canvas.Brush.Color:= clWebLightCyan
      else
        Canvas.Brush.Color:= clWebHoneydew;
      Canvas.font.Color:= clwindowtext;
      Rect.Left:= Rect.Left - 4;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 6, Rect.Top + 2, Cells[ACol, ARow]);
    end
  else if (SgBlocks.Cells[1, ARow] <> 'Line') then
    with SgBlocks do begin
      Canvas.Brush.Color:= clWebLightYellow;
      Canvas.font.Color:= clwindowtext;
      Rect.Left:= Rect.Left - 4;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 6, Rect.Top + 2, Cells[ACol, ARow]);
    end;
end;

procedure TForm1.SgBlocksExit(Sender: TObject);
begin
  RefreshTable;
  RefreshBitmap;
end;

procedure TForm1.SgBlocksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 114 then
    FindNextMove1Click(Sender);
end;

procedure TForm1.SgBlocksMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col, Row: Integer;
  pt: TPoint;
begin
  if Button = mbRight then begin
    pt:= SgBlocks.ClientToScreen(Point(X, Y));
    PopupMenu1.Popup(pt.X, pt.Y);
    SgBlocks.MouseToCell(X, Y, Col, Row);
    SgBlocks.Col:= Col;
    SgBlocks.Row:= Row;
    SelectedRow:= Row;
  end;
end;

procedure TForm1.BtnClearTableClick(Sender: TObject);
begin
  HPGLfileCount:= 0;
  SgFiles.RowCount:= 2;
  SgFiles.Cells[0, 0]:= '#';
  SgFiles.Cells[1, 0]:= 'Start';
  SgFiles.Cells[2, 0]:= 'End';
  SgFiles.Cells[3, 0]:= 'Filename';
  SgFiles.Cells[0, 1]:= '0';
  SgFiles.Cells[2, 1]:= '';
  SgFiles.Cells[3, 1]:= '';

  SgBlocks.RowCount:= 2;
  SgBlocks.Cells[0, 0]:= '#';
  SgBlocks.Cells[1, 0]:= 'Cmd';
  SgBlocks.Cells[2, 0]:= 'Raw X';
  SgBlocks.Cells[3, 0]:= 'Raw Y';
  SgBlocks.Cells[4, 0]:= 'X';
  SgBlocks.Cells[5, 0]:= 'Y';
  SgBlocks.Cells[0, 1]:= '0';
  SgBlocks.Cells[1, 1]:= '';
  SgBlocks.Cells[2, 1]:= '';
  SgBlocks.Cells[3, 1]:= '';
  SgBlocks.Cells[4, 1]:= '0';
  SgBlocks.Cells[5, 1]:= '0';
  ScrollOffsX:= 0;
  ScrollOffsY:= 0;
  ValidSection:= false;
  SelectedRow:= 1;
  SgBlocks.Row:= 1;
  CreateObjects(true);
end;

procedure TForm1.BtnReprocessClick(Sender: TObject);
begin
  SgBlocks.RowCount:= 2;
  ValidSection:= false;
  SelectedRow:= 1;
  SgBlocks.Row:= 1;
  HPGLfileLoad(OpenDialog1.filename, false);
  RenumberSg;
  Application.ProcessMessages;
  ScrollOffsX:= 0;
  ScrollOffsY:= 0;
  RefreshTable;
  RefreshBitmap;
  CreateObjects(true);
  SgBlocks.FixedRows:= 1;
end;

procedure TForm1.BtnSendBitmapClick(Sender: TObject);
var
  idx: Integer;
  my_val: Integer;
  Bitmap: tBitmap;
  pixel: tColor;
  sendbyte: Byte;
begin
  OpenDialog1.FilterIndex:= 4;
  OpenDialog1.DefaultExt:= '*.bmp';
  OpenDialog1.Title:= 'Open Bitmap File):';
  if OpenDialog1.Execute then begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.LoadFromFile(OpenDialog1.FileName);
      Paintbox1.Canvas.Draw(0, 0, Bitmap);
      if ComPort1.Connected then begin
        // Sprite-Auswahl, Variation and Visible (# + 4), zunächst unsichtbar
        ComPort1.WriteStr(IntToStr(66 + (ComboBox1.ItemIndex * 4)) + '=' + IntToStr(ComboBox2.ItemIndex) + #13);
        ComPort1.WriteStr(IntToStr(170 + ComboBox1.ItemIndex) + '=2048' + #13);  // 1024 Words =2048 Bytes
        ProgressBar1.Max:= 1024;
        Sleep(20);
        for idx:= 0 to 1023 do begin
          pixel:= Bitmap.Canvas.Pixels[idx mod 32, idx div 32];
          my_val:= (pixel and $E00000) shr 22; // Blau in Bit 0, 1
          my_val:= my_val or ((pixel and $00E000) shr 11); // Grün in Bit 2..4
          my_val:= my_val or (pixel and $0000E0); // Rot  in Bit 7..5
          if pixel = $FF00FF then
            my_val:= 256;
          sendbyte:= lo(my_val);
          ComPort1.Write(sendbyte, 1);
          sendbyte:= hi(my_val);
          ComPort1.Write(sendbyte, 1);
          ProgressBar1.Position:= idx;
          Sleep(1);
        end;
        // Geladenes Sprite sichtbar schalten
        ComPort1.WriteStr(IntToStr(66 + (ComboBox1.ItemIndex * 4)) + '=' + IntToStr(ComboBox2.ItemIndex + 4) + #13);
      end;
    finally
      Bitmap.Free;
    end;
    ProgressBar1.Position:= 0;
    Memo1.Lines.Add('Done.');
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if ComPort1.Connected then
    ComPort1.WriteStr(IntToStr(66 + (ComboBox1.ItemIndex*4)) + '=' + IntToStr(ComboBox2.ItemIndex + 4) + #13);
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  if ComPort1.Connected then
    ComPort1.WriteStr(IntToStr(66 + (ComboBox1.ItemIndex*4)) + '=' + IntToStr(ComboBox2.ItemIndex + 4) + #13);
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  if ComPort1.Connected then
    ComPort1.WriteStr(IntToStr(64 + (ComboBox1.ItemIndex*4)) + '=' + IntToStr(ScrollBar1.Position) + #13);
  Sleep(5);
end;


procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  if ComPort1.Connected then
    ComPort1.WriteStr(IntToStr(65 + (ComboBox1.ItemIndex*4)) + '=' + IntToStr(ScrollBar2.Position) + #13);
  Sleep(5);
end;

procedure TForm1.BtnSendClick(Sender: TObject);
var
  my_row: Integer;
begin
  ComPort1.WriteStr('140=0' + #13);
  Sleep(20);
  ProgressBar1.Max:= SgBlocks.RowCount - 1;
  for my_row:= 1 to SgBlocks.RowCount - 1 do  begin
    if CheckBoxReplaceSkip.Checked and (SgBlocks.Cells[1, my_row] = 'Skip') then
      ComPort1.WriteStr('141=' + IntToStr(c_nop) + #13)
    else
      ComPort1.WriteStr('141=' + IntToStr(RowToVec(my_row)) + #13);
    Sleep(1);
    ProgressBar1.Position:= my_row;
  end;
  Sleep(5);
  ComPort1.WriteStr('142=0' + #13); // Run
  ProgressBar1.Position:= 0;
  Memo1.Lines.Add('Done.');
end;

procedure TForm1.BtnSendResetClick(Sender: TObject);
begin
  ComPort1.WriteStr('999' + #13);
  Sleep(20);
  Memo1.Lines.Add('Send Reset done.');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  BtnSend.Enabled:= ComPort1.Connected;
  BtnSendFPGA.Enabled:= ComPort1.Connected;
  BtnSendReset.Enabled:= ComPort1.Connected;
end;

procedure TForm1.TrackBarScaleChange(Sender: TObject);
begin
  RefreshTable;
  RefreshBitmap;
  if GetAsyncKeyState(VK_LBUTTON) = 0 then
    CreateObjects(true);
end;

procedure TForm1.ButtonExportVectorFileClick(Sender: TObject);
var
  binfilestream: TFileStream;
  my_row: Integer;
  vec: LongWord;
begin
  SaveDialog1.FilterIndex:= 1;
  SaveDialog1.DefaultExt:= '';
  SaveDialog1.Title:= 'Save binary Vector (VEC) File):';
  if SaveDialog1.Execute then
    try
      binfilestream:= TFileStream.Create(SaveDialog1.filename, fmCreate);
      binfilestream.Position:= 0;
      for my_row:= 1 to SgBlocks.RowCount - 1 do
        if SgBlocks.Cells[1, my_row] <> '' then
        begin
          vec:= RowToVec(my_row);
          binfilestream.Write(vec, 4);
        end;
    finally
      binfilestream.Free;
    end;
end;

end.
