program hpgl_to_pas;

uses
  Vcl.Forms,
  hpgl_to_arr_main in 'hpgl_to_arr_main.pas' {Form1},
  CPort in 'CPort\Source\CPort.pas',
  CPortAbout in 'CPort\Source\CPortAbout.pas' {AboutBox},
  CPortCtl in 'CPort\Source\CPortCtl.pas',
  CPortEsc in 'CPort\Source\CPortEsc.pas',
  CPortMonitor in 'CPort\Source\CPortMonitor.pas',
  CPortSetup in 'CPort\Source\CPortSetup.pas',
  CPortTrmSet in 'CPort\Source\CPortTrmSet.pas' {ComTrmSetForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
