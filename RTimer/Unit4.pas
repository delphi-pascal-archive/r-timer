unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, pngimage, ExtCtrls, jpeg, IniFiles, ShlObj;

type
  TForm4 = class(TForm)
    CheckBox1: TCheckBox;
    TrackBar1: TTrackBar;
    CheckBox4: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    Image1: TImage;
    CheckBox2: TCheckBox;
    TrackBar2: TTrackBar;
    Label1: TLabel;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  IniFile: TIniFile;
implementation

uses Unit1, Unit3, Unit5;

{$R *.dfm}



procedure TForm4.CheckBox10Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','Cyclically',Form4.CheckBox10.Checked);
end;

procedure TForm4.CheckBox11Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','Volume',Form4.CheckBox11.Checked);
end;

procedure TForm4.CheckBox12Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','Autolaunch',Form4.CheckBox12.Checked);
end;

procedure TForm4.CheckBox1Click(Sender: TObject);
begin
if CheckBox1.Checked=true then
begin
Form1.AlphaBlend:=True;
Form3.AlphaBlend:=True;
Form4.AlphaBlend:=True;
end
else
begin
Form1.AlphaBlend:=False;
Form3.AlphaBlend:=False;
Form4.AlphaBlend:=False;
end;

IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','AlphaBlend',Form4.CheckBox1.Checked);
end;

procedure TForm4.CheckBox2Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','ShowTime',Form4.CheckBox2.Checked);
end;

procedure TForm4.CheckBox3Click(Sender: TObject);
Var s: string;
begin
SetLength(s, MAX_PATH);

if CheckBox3.Checked then
  begin
    if not SHGetSpecialFolderPath(0, PChar(s), $0018, true)
    then s := '' else
      begin
      CreateLink(ParamStr(0), PChar(s)+'\RTimer.lnk', '', '');
      IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
      IniFile.WriteBool('Settings','AutoStart',Form4.CheckBox3.Checked);
      end;
  end

else
begin
  if not SHGetSpecialFolderPath(0, PChar(s), $0018, true)
  then s := ''
  else
  begin
    DeleteFile(PChar(s)+'\RTimer.lnk');
    IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
    IniFile.WriteBool('Settings','AutoStart',Form4.CheckBox3.Checked);
  end;
end;

end;

procedure TForm4.CheckBox4Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','Classic',Form4.CheckBox4.Checked);
If Load=True then
Application.MessageBox('          Для принятия изменений'+#13+'необходимо перезапустить программу!', PChar(unit1.version),mb_OK);
end;

procedure TForm4.CheckBox5Click(Sender: TObject);
begin
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','StartMin',Form4.CheckBox5.Checked);
end;

procedure TForm4.CheckBox6Click(Sender: TObject);
begin
if CheckBox6.Checked then
  begin
    Form1.ScreenSnap:=true;
    Form1.SnapBuffer:=10;
    Form5.ScreenSnap:=true;
    Form5.SnapBuffer:=10;
  end
  Else
  begin
    Form1.ScreenSnap:=False;
    Form1.SnapBuffer:=10;
    Form5.ScreenSnap:=False;
    Form5.SnapBuffer:=10;
  end;
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','Adhesion',Form4.CheckBox6.Checked);
end;

procedure TForm4.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.Checked then
  begin
    Form1.BitBtn4.ShowHint:=False;
    Form1.BitBtn3.ShowHint:=False;
    Form1.BitBtn1.ShowHint:=False;
    Form1.Button3.ShowHint:=False;
    Form1.SpinEdit2.ShowHint:=False;
    Form1.SpinEdit3.ShowHint:=False;
    Form1.CheckBox1.ShowHint:=False;
    CheckBox4.ShowHint:=False;
    CheckBox12.ShowHint:=False;
  end
  else
  begin
    Form1.BitBtn4.ShowHint:=True;
    Form1.BitBtn3.ShowHint:=True;
    Form1.BitBtn1.ShowHint:=True;
    Form1.Button3.ShowHint:=True;
    Form1.SpinEdit2.ShowHint:=True;
    Form1.SpinEdit3.ShowHint:=True;
    Form1.CheckBox1.ShowHint:=True;
    CheckBox4.ShowHint:=True;
    CheckBox12.ShowHint:=True;
  end;

IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteBool('Settings','ShowHint',Form4.CheckBox7.Checked);
end;

procedure TForm4.CheckBox8Click(Sender: TObject);
begin
if CheckBox8.Checked=true then Form4.FormStyle:=FsStayOnTop
else Form4.FormStyle:=FsNormal;

IniFile:=TIniFile.Create(ExtractFilePath(application.exename)+'Settings.ini');
IniFile.WriteBool('Settings','Over',Form4.CheckBox8.Checked);

end;

procedure TForm4.CheckBox9Click(Sender: TObject);
begin
if CheckBox9.Checked=true then ShowWindow(Application.Handle, sw_Hide)
else ShowWindow(Application.Handle, sw_Show);

IniFile:=TIniFile.Create(ExtractFilePath(application.exename)+'Settings.ini');
IniFile.WriteBool('Settings','ShowPonelTasks',Form4.CheckBox9.Checked);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
InitProg;
Load:=True;
if Form4.CheckBox12.Checked then Form1.BitBtn2.Click;
end;

procedure TForm4.TrackBar1Change(Sender: TObject);
begin
Form1.AlphaBlendValue:=255-TrackBar1.Position;
Form3.AlphaBlendValue:=Form1.AlphaBlendValue;
Form4.AlphaBlendValue:=Form1.AlphaBlendValue;
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteInteger('Settings','AlphaBlendValue',Form4.TrackBar1.Position);
end;

procedure TForm4.TrackBar2Change(Sender: TObject);
begin
Form5.AlphaBlendValue:=255-TrackBar2.Position;
IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
IniFile.WriteInteger('Settings','AlphaBlendValue5',Form4.TrackBar2.Position);
end;

end.
