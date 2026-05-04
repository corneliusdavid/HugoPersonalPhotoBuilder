unit ufrmBuildHugoPhotosDesktopMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.ListBox, FMX.Layouts;

type
  TfrmBuildHugoPhotosDesktopMain = class(TForm)
    aclAlbumBuilder: TActionList;
    actPreviousTab: TPreviousTabAction;
    actNextTab: TNextTabAction;
    TabControl: TTabControl;
    tabParams: TTabItem;
    tabLog: TTabItem;
    BottomToolBar: TToolBar;
    edtTitle: TEdit;
    lblTitle: TLabel;
    edtLocations: TEdit;
    lblLocations: TLabel;
    edtDesc: TMemo;
    lblDesc: TLabel;
    edtTopic: TEdit;
    lblTopic: TLabel;
    cmbTopicPrefix: TComboBox;
    lblTopicHelp: TLabel;
    edtSrc: TEdit;
    lblSourceFolder: TLabel;
    edtThumb: TEdit;
    lblThumb: TLabel;
    edtTags: TEdit;
    lblTags: TLabel;
    lblTagHelp: TLabel;
    lbLog: TListBox;
    btnLogDone: TButton;
    btnBuildPage: TButton;
    actBuildAlbumPage: TAction;
    actBackToMain: TAction;
    StyleBook: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure actBuildAlbumPageExecute(Sender: TObject);
    procedure actBackToMainExecute(Sender: TObject);
  private
    function AllFieldsFilled: Boolean;
    function SourceFolderExists: Boolean;
  public
    { Public declarations }
  end;

var
  frmBuildHugoPhotosDesktopMain: TfrmBuildHugoPhotosDesktopMain;

implementation

{$R *.fmx}

uses
  IOUtils,
  uAlbumInfo,
  uBuildAlbumPage;

procedure TfrmBuildHugoPhotosDesktopMain.actBackToMainExecute(Sender: TObject);
begin
  actPreviousTab.Execute;

  edtTitle.Text := EmptyStr;
  edtDesc.Text  := EmptyStr;
  edtLocations.Text := EmptyStr;
  edtTopic.Text := EmptyStr;
  edtThumb.Text := EmptyStr;
  edtTags.Text  := EmptyStr;
  edtSrc.Text   := EmptyStr;
  edtTitle.SetFocus;
end;

procedure TfrmBuildHugoPhotosDesktopMain.actBuildAlbumPageExecute(Sender: TObject);
var
  NewAlbum: TAlbumInfo;
begin
  if AllFieldsFilled and SourceFolderExists then begin
    actNextTab.Execute;

    NewAlbum.Title     := edtTitle.Text;
    NewAlbum.Desc      := edtDesc.Text;
    NewAlbum.Locations := edtLocations.Text;
    NewAlbum.Topic     := cmbTopicPrefix.Items[cmbTopicPrefix.ItemIndex] + '\' + edtTopic.Text;
    NewAlbum.Thumb     := edtThumb.Text;
    NewAlbum.Tags      := edtTags.Text;
    NewAlbum.Src       := edtSrc.Text;

    BuildAlbumPage(NewAlbum, procedure (const s: string)
                   begin
                     lbLog.Items.Add(s);
                   end);
  end;
end;

function TfrmBuildHugoPhotosDesktopMain.AllFieldsFilled: Boolean;
begin
  Result := False;

  if edtTitle.Text.IsEmpty then begin
    edtTitle.SetFocus;
    ShowMessage('"Title" is required.');
  end else if edtLocations.Text.IsEmpty then begin
    edtLocations.SetFocus;
    ShowMessage('At least one "Location" is required.');
  end else if edtTopic.Text.IsEmpty then begin
    edtTopic.SetFocus;
    ShowMessage('Enter the "Web Folder" for the new sub-album.');
  end else if edtSrc.Text.IsEmpty then begin
    edtSrc.SetFocus;
    ShowMessage('Paste the "Source Folder" of the picture files.');
  end else if edtThumb.Text.IsEmpty then begin
    edtThumb.SetFocus;
    ShowMessage('List the filename of the "Thumbnail" for this new sub-album.');
  end else
    Result := True;
end;

procedure TfrmBuildHugoPhotosDesktopMain.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl.First(TTabTransition.None);
end;

procedure TfrmBuildHugoPhotosDesktopMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (TabControl.TabIndex <> 0) then
  begin
    TabControl.First;
    Key := 0;
  end;
end;

function TfrmBuildHugoPhotosDesktopMain.SourceFolderExists: Boolean;
begin
  Result := TDirectory.Exists(edtSrc.Text);

  if not Result then begin
    edtSrc.SetFocus;
    ShowMessage('Please enter a valid "Source Folder" where the pictures currently reside.');
  end;
end;

end.
