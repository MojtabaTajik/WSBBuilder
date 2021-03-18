unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls, Vcl.Samples.Spin, Vcl.FileCtrl,
  WSConfig, System.Generics.Collections, Vcl.ExtCtrls, Winapi.ShellAPI;

type
  TFrmMain = class(TForm)
    grpOptions: TGroupBox;
    cbGPU: TComboBox;
    cbNetwork: TComboBox;
    lblVGPU: TLabel;
    lblNetwork: TLabel;
    lblAudioInput: TLabel;
    lblVideoInput: TLabel;
    cbbAudioInput: TComboBox;
    cbbVideoInput: TComboBox;
    lblProtectedClient: TLabel;
    cbbProtectedClient: TComboBox;
    lblPrinterRedirect: TLabel;
    cbPrinterRedirect: TComboBox;
    lblClipboardRedirect: TLabel;
    cbClipboardRedirect: TComboBox;
    lblCommand: TLabel;
    edCommand: TEdit;
    lblMemory: TLabel;
    btnSave: TButton;
    seMemory: TSpinEdit;
    dlgSave: TSaveDialog;
    grpShareFolder: TGroupBox;
    edtSandboxShareRoot: TEdit;
    lblSandboxShareRoot: TLabel;
    lblSharedFolders: TLabel;
    chlbShared: TCheckListBox;
    btnRemoveSHaredDir: TButton;
    btnAddSharedDir: TButton;
    llblAbout: TLinkLabel;
    procedure btnAddSharedDirClick(Sender: TObject);
    procedure btnRemoveSHaredDirClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure llblAboutLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.btnAddSharedDirClick(Sender: TObject);
var
  Dir: string;
begin
  if (SelectDirectory('Select directory to share:', '', Dir)) then
    chlbShared.Items.Add(Dir);
end;

procedure TFrmMain.btnRemoveSHaredDirClick(Sender: TObject);
begin
  if (chlbShared.ItemIndex <= -1) then
    Exit;

  if MessageBox(0, 'Remove this shared folder?', nil,
    MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    chlbShared.DeleteSelected;
  end;
end;

procedure TFrmMain.btnSaveClick(Sender: TObject);
var
  WSConfig: TWSConfig;
  BuildResult: Boolean;

  SharedFoldersDic: TDictionary<string, Boolean>;
  I: Integer;
begin
  if (not dlgSave.Execute()) then
    Exit;

  WSConfig := TWSConfig.Create;
  SharedFoldersDic := TDictionary<string, Boolean>.Create();
  try
    for I := 0 to chlbShared.Items.Count - 1 do
      SharedFoldersDic.Add(chlbShared.Items[I], chlbShared.Checked[I]);

    With WSConfig do
    begin
      vGpu := cbGPU.Text;
      Network := cbNetwork.Text;
      AudioInput := cbbAudioInput.Text;
      VideoInput := cbbVideoInput.Text;
      ProtectedClient := cbbProtectedClient.Text;
      PritnerRedirect := cbPrinterRedirect.Text;
      ClipboardRedirect := cbClipboardRedirect.Text;
      Command := edCommand.Text;
      Memory := seMemory.Value;
      SharedFolders := SharedFoldersDic;
    end;

    BuildResult := WSConfig.Build(edtSandboxShareRoot.Text, dlgSave.FileName);
  finally
    WSConfig.Free;
    SharedFoldersDic.Free;
  end;

  if (BuildResult) then
    MessageBox(0, 'WSB saved successfully.', nil, MB_OK + MB_ICONINFORMATION)
  else
    MessageBox(0, 'Failed to save WSB.', nil, MB_OK + MB_ICONERROR);

end;

procedure TFrmMain.llblAboutLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Handle, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
