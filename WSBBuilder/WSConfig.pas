unit WSConfig;

interface

uses
  System.SysUtils, System.StrUtils, System.Classes, System.IOUtils,
  System.Generics.Collections, XMLIntf, XMLDoc;

type
  TWSConfig = class
  private
    FMemory: Integer;
    FGPU: string;
    FNetwork: string;
    FAudioInput: string;
    FVideoInput: string;
    FProtectedClient: string;
    FPrinterRed: string;
    FClipboardRed: string;
    FCommand: string;
    FSharedFolders: TDictionary<string, Boolean>;
  public
    function Build(ShareRoot, FilePath: string): Boolean;

    property vGpu: string read FGPU write FGPU;
    property Network: string read FNetwork write FNetwork;
    property AudioInput: string read FAudioInput write FAudioInput;
    property VideoInput: string read FVideoInput write FVideoInput;
    property ProtectedClient: string read FProtectedClient
      write FProtectedClient;
    property PritnerRedirect: string read FPrinterRed write FPrinterRed;
    property ClipboardRedirect: string read FClipboardRed write FClipboardRed;
    property Memory: Integer read FMemory write FMemory;
    property Command: string read FCommand write FCommand;
    property SharedFolders: TDictionary<string, Boolean> read FSharedFolders
      write FSharedFolders;
  end;

implementation

{ TWSBBuilder }

function TWSConfig.Build(ShareRoot, FilePath: string): Boolean;
var
  ConfigName: string;
  XMLDoc: IXMLDocument;
  ConfigNode: IXMLNode;
  MappedFolders: IXMLNode;
  MappedFolder: IXMLNode;

  ShareFolder: TPair<string, Boolean>;
  TempDirName: string;
begin
  Result := True;

  ConfigName := TPath.GetFileName(FilePath);

  XMLDoc := NewXMLDocument;
  ConfigNode := XMLDoc.AddChild('Configuration');
  ConfigNode.Attributes['Name'] := ConfigName;
  ConfigNode.Attributes['CreatedAt'] := DateToStr(Now);

  ConfigNode.AddChild('VGpu').Text := vGpu;
  ConfigNode.AddChild('Networking').Text := Network;
  ConfigNode.AddChild('AudioInput').Text := AudioInput;
  ConfigNode.AddChild('VideoInput').Text := VideoInput;
  ConfigNode.AddChild('ProtectedClient').Text := ProtectedClient;
  ConfigNode.AddChild('PrinterRedirection').Text := PritnerRedirect;
  ConfigNode.AddChild('ClipboardRedirection').Text := ClipboardRedirect;
  ConfigNode.AddChild('MemoryInMB').Text := IntToStr(Memory);

  if (Command <> EmptyStr) then
    ConfigNode.AddChild('LogonCommand').AddChild('Command').Text := Command;

  MappedFolders := ConfigNode.AddChild('MappedFolders');
  for ShareFolder in FSharedFolders do
  begin
    TempDirName := TPath.GetFileName(ShareFolder.Key);

    MappedFolder := MappedFolders.AddChild('MappedFolder');
    MappedFolder.AddChild('HostFolder').Text := ShareFolder.Key;
    MappedFolder.AddChild('SandboxFolder').Text :=
      TPath.Combine(ShareRoot, TempDirName);
    MappedFolder.AddChild('ReadOnly').Text :=
      IfThen(ShareFolder.Value, 'true', 'false');
  end;

  XMLDoc.SaveToFile(FilePath);
end;

end.
