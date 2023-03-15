unit uAlbumInfo;

interface

type
  TAlbumInfo = record
    Title: string;
    Desc: string;
    Locations: string;
    Topic: string;
    Thumb: string;
    Tags: string;
    Src: string;
    class operator Initialize(out Dest: TAlbumInfo);
  end;



implementation

uses
  System.SysUtils;

{ TAlbumInfo }

class operator TAlbumInfo.Initialize(out Dest: TAlbumInfo);
begin
  Dest.Title := EmptyStr;
  Dest.Desc := EmptyStr;
  Dest.Locations := EmptyStr;
  Dest.Topic := EmptyStr;
  Dest.Thumb := EmptyStr;
  Dest.Tags := EmptyStr;
  Dest.Src := EmptyStr;
end;


end.
