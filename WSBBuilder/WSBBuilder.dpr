program WSBBuilder;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FrmMain},
  WSConfig in 'WSConfig.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
