unit uBuildAlbumPage;

interface

uses
  System.Classes,
  uAlbumInfo;

type
  TLogProc = reference to procedure(const LogMsg: string);

function BuildAlbumPage(const Album: TAlbumInfo; LogProc: TLogProc): Boolean;

implementation

uses
  System.SysUtils,
  System.Types,
  System.StrUtils,
  System.DateUtils,
  IOUtils;


const
  WEB_ROOT = 'e:\web\www.corneliusconcepts.pictures';


function BuildAlbumPage(const Album: TAlbumInfo; LogProc: TLogProc): Boolean;
var
  ContentFile: TextFile;
  EarliestFileDT: TDateTime;
  CurrFileDT: TDateTime;
  AssetsDestPath: string;
  ContentDestPath: string;
  ImageFileList: TStringDynArray;
  FileLines: TStringList;
begin
  Result := False;

  // create assets folder for images
  AssetsDestPath := TPath.Combine(TPath.Combine(WEB_ROOT, 'assets'), Album.Topic);
  TDirectory.CreateDirectory(AssetsDestPath);
  LogProc('Created Assets Directory: ' + AssetsDestPath);

  // create content folder for _index.md
  ContentDestPath := TPath.Combine(TPath.Combine(WEB_ROOT, 'content'), Album.Topic);
  TDirectory.CreateDirectory(ContentDestPath);
  LogProc('Created Content Directory: ' + ContentDestPath);

  FileLines := TStringList.Create;
  try
    // create content index file
    FileLines.Add('---');
    FileLines.Add(Format('title: "%s"', [Album.Title]));
    FileLines.Add(Format('description: "%s"', [Album.Desc]));
    FileLines.Add(Format('locations: [%s]', [Album.Locations]));
    FileLines.Add('draft: false');
    FileLines.Add(Format('albumthumb: %s', [ReplaceStr(TPath.Combine(Album.Topic, Album.Thumb), '\', '/')]));
    FileLines.Add(Format('tags: [%s]', [Album.Tags]));
    FileLines.Add('resources:');

    // keep track of earliest file date of images to copy
    EarliestFileDT := 0;

    // Copy all images from source folder to destination folder
    ImageFileList := TDirectory.GetFiles(Album.Src,
                        function(const Path: string; const SearchRec: TSearchRec): Boolean
                        begin
                          Result := (SearchRec.Attr and faDirectory = 0) and
                                    (SameText(ExtractFileExt(SearchRec.Name), '.jpg') or
                                     SameText(ExtractFileExt(SearchRec.Name), '.jpeg'));

                        end);

    for var Src in ImageFileList do begin
      var Dst := TPath.Combine(AssetsDestPath, ExtractFileName(Src));
      LogProc(Format('Copying %s to %s...', [Src, Dst]));
      TFile.Copy(Src, Dst);
      FileLines.Add('- ' + ExtractFileName(Src));

      // save the earliest file date from the list
      FileAge(Src, CurrFileDT);
      if (EarliestFileDT = 0) or (CurrFileDT < EarliestFileDT) then
        EarliestFileDT := CurrFileDT;
    end;

    FileLines.Add(Format('date: %s', [DateToISO8601(EarliestFileDT, False)]));
    FileLines.Add('---');

    FileLines.SaveToFile(TPath.Combine(ContentDestPath, '_index.md'));

    Result := True;
  finally
    FileLines.Free;
  end;
end;


end.
