unit dotenv;

interface

uses
  SysUtils, Classes;

procedure LoadEnvFile(const FileName: string);
function GetEnvVar(const VarName: string): string;

implementation

var
  EnvMap: TStringList;

procedure LoadEnvFile(const FileName: string);
var
  F: TStringList;
  I: Integer;
  Line, Key, Value: string;
begin
  EnvMap := TStringList.Create;
  F := TStringList.Create;
  try
    F.LoadFromFile(FileName);
    for I := 0 to F.Count - 1 do
    begin
      Line := Trim(F.Strings[I]);
      if (Line = '') or (Line[1] = '#') then Continue;
      Key := Trim(Copy(Line, 1, Pos('=', Line) - 1));
      Value := Trim(Copy(Line, Pos('=', Line) + 1, Length(Line)));
      EnvMap.Values[Key] := Value;
    end;
  finally
    F.Free;
  end;
end;

function GetEnvVar(const VarName: string): string;
begin
  Result := EnvMap.Values[VarName];
end;

end.
