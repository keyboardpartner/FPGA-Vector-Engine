unit rtc_maxim;

interface
// global part

{ $W+}                  // enable/disable warnings for this unit

{$IDATA}
const
  rtc_adr: Byte = $68;  // DS3231
  c_daypermonthArr: Array[0..11] of Int8 = (
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
type
  t_date = Record
    weekday, day, month, year: Byte;
  end;

  t_time = Record
    second, minute, hour: Byte;
  end;

var
  DS_present: Boolean;
  Sec100: Byte;

  TimeDateArr: Array[0..7] of Byte;
    Second[@TimeDateArr + 0]: Byte;
    Minute[@TimeDateArr + 1]: Byte;
    Hour[@TimeDateArr + 2]: Byte;

    Weekday[@TimeDateArr + 4]: Byte;
    Day[@TimeDateArr + 5]: Byte;
    Month[@TimeDateArr + 6]: Byte;
    Year[@TimeDateArr + 7]: Byte;

  SecondSema, MinuteSema, HourSema: Boolean;

procedure DS_writeRAM(const ram_addr, data: byte);
function DS_readRAM(const ram_addr: Byte): byte;

procedure DS_GetTime(var second, minute, hour: Byte);
procedure DS_SetTime(const second, minute, hour: Byte);

procedure DS_GetDate(var weekday, day, month, year: Byte);
procedure DS_SetDate(const weekday, day, month, year: Byte);
procedure DS_Init;

Function CalcDays(const day, month, year: Byte): Integer;
procedure GetRTCtime;
procedure GetRTCdate;
procedure SetRTCtime;
procedure SetRTCdate;

implementation

var
  hour_temp, minute_temp, second_temp: Byte;
  weekday_temp, day_temp, month_temp, year_temp: Byte;

{$IDATA}
{
Function CalcDays(const my_date: t_date): Integer;
// Tage vom 1.1.2000 bis Datum
var temp_days: Integer; idx: Byte;
begin
  temp_days:= 0;
  // Tage bis zum 31.12. letzten Jahres
  if my_date.year > 0 then
    for idx:= 0 to my_date.year - 1 do
      temp_days:= temp_days + 365;
      if idx mod 4 = 0 then
        inc(temp_days);
      endif;
    endfor;
  endif;
  // plus Tage der Monate bis letzen Monat
  if my_date.month > 1 then
    for idx:= 1 to my_date.month - 1 do
      temp_days:= temp_days + Integer(c_daypermonthArr[idx - 1]);
    endfor;
  endif;
  // plus Tage aktueller Monat
  temp_days:= temp_days + Integer(my_date.day - 1);
  return(temp_days);
end;
}

Function CalcDays(const day, month, year: Byte): Integer;
// Tage vom 1.1.2000 bis Datum
var temp_days: Integer; idx: Byte;
begin
  temp_days:= 0;
  // Tage bis zum 31.12. letzten Jahres
  if year > 0 then
    for idx:= 0 to year - 1 do
      temp_days:= temp_days + 365;
      if idx mod 4 = 0 then
        inc(temp_days);
      endif;
    endfor;
  endif;
  // plus Tage der Vormonate
  if month > 1 then
    for idx:= 1 to month - 1 do
      temp_days:= temp_days + Integer(c_daypermonthArr[idx - 1]);
    endfor;
  endif;
  // ist aktuelles Jahr ein Schaljahr und min. März?
  if (month > 2) and (year mod 4 = 0) then
    inc(temp_days);
  endif;
  // plus Tage aktueller Monat
  temp_days:= temp_days + Integer(day - 1);
  return(temp_days);
end;

procedure SetRTCdate;
begin
  DisableInts;
  RTCsetWeekday(weekday);  // 0 = Sonntag
  RTCsetDay(day);
  RTCsetMonth(month);
  RTCsetYear(year);
  EnableInts;
end;

procedure GetRTCtime;
begin
  second:= RTCgetSecond;
  minute:= RTCgetMinute;
  hour:= RTCgetHour;
end;

procedure GetRTCdate;
begin
  weekday:= RTCgetWeekday;
  day:= RTCgetDay;
  month:= RTCgetMonth;
  year:= RTCgetYear;
end;

procedure SetRTCtime;
begin
  DisableInts;
  RTCsetSecond(second);
  RTCsetMinute(minute);
  RTCsetHour(hour);
  EnableInts;
end;

//##############################################################################

procedure DS_writeRAM(ram_addr, data: byte);
begin
  if DS_present then
    ram_addr:= ram_addr + 8;
    TWIout(rtc_adr, ram_addr, data); // RAM-Register
  endif;
end;

function DS_readRAM(ram_addr: Byte): byte;
var my_byte: byte;
begin
  if DS_present then
    ram_addr:= ram_addr + 8;
    TWIout(rtc_adr, ram_addr); // RAM-Register
    TWIinp(rtc_adr, my_byte);
    return(my_byte);
  else
    return(0);
  endif;
end;

// -----------------------------------------------------------------------------

procedure DS_GetTime(var second, minute, hour: Byte);
var my_bcd: Byte;
begin
  if DS_present then
    TWIout(rtc_adr, 0); // Sekunden-Register, BCD
    TWIinp(rtc_adr, my_bcd);
    second:= BCDtoByte(my_bcd);
    TWIout(rtc_adr, 1); // Minuten-Register, BCD
    TWIinp(rtc_adr, my_bcd);
    minute:= BCDtoByte(my_bcd);
    TWIout(rtc_adr, 2); // Stunden-Register, BCD
    TWIinp(rtc_adr, my_bcd);
    hour:= BCDtoByte(my_bcd and $3F);
  endif;
end;

procedure DS_GetDate(var weekday, day, month, year: Byte);
var my_bcd: Byte;
begin
  if DS_present then
    TWIout(rtc_adr, 3); // Wochentags-Register
    TWIinp(rtc_adr, my_bcd);
    weekday:= my_bcd and 7;
    TWIout(rtc_adr, 4); // Datums-Register, BCD
    TWIinp(rtc_adr, my_bcd);
    day:= BCDtoByte(my_bcd and $3F);
    TWIout(rtc_adr, 5);
    TWIinp(rtc_adr, my_bcd);
    month:= BCDtoByte(my_bcd and $1F);
    TWIout(rtc_adr, 6);
    TWIinp(rtc_adr, my_bcd);
    year:= BCDtoByte(my_bcd);
  endif;
end;

// -----------------------------------------------------------------------------

Procedure DS_SetTime(const second, minute, hour: Byte);
var my_bcd: Byte;
begin
  if DS_present then
    my_bcd:= ByteToBCD(second);
    TWIout(rtc_adr, 0, my_bcd); // Sekunden-Register, BCD
    my_bcd:= ByteToBCD(Minute);
    TWIout(rtc_adr, 1, my_bcd); // Minuten-Register, BCD
    my_bcd:= ByteToBCD(hour) and $1F;
    TWIout(rtc_adr, 2, my_bcd); // Stunden-Register, BCD
  endif;
end;

procedure DS_SetDate(const weekday, day, month, year: Byte);
var my_bcd: Byte;
begin
  if DS_present then
    TWIout(rtc_adr, 3, weekday);
    my_bcd:= ByteToBCD(day);
    TWIout(rtc_adr, 4, my_bcd);
    my_bcd:= ByteToBCD(month);
    TWIout(rtc_adr, 5, my_bcd);
    my_bcd:= ByteToBCD(year);
    TWIout(rtc_adr, 6, my_bcd);
  endif;
end;

procedure DS_Init;
var my_ctrl_reg: Byte;
begin
  DS_present:= TWIstat(rtc_adr);
  if DS_present then
    my_ctrl_reg:= %01011000;
    TWIout(rtc_adr, $E, my_ctrl_reg);
    mDelay(1);
    DS_GetTime(second, minute, hour);
    if Hour > 23 then
      Hour:= 0;
      DS_SetTime(second, minute, hour);
    endif;
    SetRTCtime;
    DS_GetDate(weekday, day, month, year);
    if Weekday > 6 then
      Weekday:= 0;
      DS_SetDate(Weekday, Day, Month, Year);
    endif;
    SetRTCdate;
  endif;
end;

end rtc_maxim.

