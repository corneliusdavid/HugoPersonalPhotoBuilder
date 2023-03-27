unit ufrmBuildHugoPhotosDesktopMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.ListBox, FMX.Layouts;

type
  TfrmBuildHugoPhotosDesktopMain = class(TForm)
    ActionList1: TActionList;
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
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure actBuildAlbumPageExecute(Sender: TObject);
    procedure actBackToMainExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBuildHugoPhotosDesktopMain: TfrmBuildHugoPhotosDesktopMain;

implementation

{$R *.fmx}

uses
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

end.
