program BuildHugoForPersonalPhotos_FMDesktop;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmBuildHugoPhotosDesktopMain in 'ufrmBuildHugoPhotosDesktopMain.pas' {frmBuildHugoPhotosDesktopMain},
  uAlbumInfo in 'uAlbumInfo.pas',
  uBuildAlbumPage in 'uBuildAlbumPage.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBuildHugoPhotosDesktopMain, frmBuildHugoPhotosDesktopMain);
  Application.Run;
end.
