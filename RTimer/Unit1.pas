unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Spin, Gauges, AppEvnts, Menus, IniFiles,
  XPMan, DateUtils, jpeg, MPlayer, Buttons, mmsystem, shellapi, pngimage, GIFImg, ShlObj,
  ComObj, ActiveX;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    Button3: TButton;
    Timer2: TTimer;
    Image1: TImage;
    BalloonHint1: TBalloonHint;
    Label3: TLabel;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Edit1: TEdit;
    OpenDialog2: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    SpinEdit1: TSpinEdit;
    CheckBox2: TCheckBox;
    SpinEdit3: TSpinEdit;
    SpinEdit2: TSpinEdit;
    RadioButton2: TRadioButton;
    Timer3: TTimer;
    BitBtn4: TBitBtn;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    XPManifest1: TXPManifest;
    CheckBox1: TCheckBox;
    MediaPlayer1: TMediaPlayer;
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;


Const
  Version:String='RTimer v4.0 Beta';

Procedure Stop;
Procedure InitProg;
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
Procedure StopOfTimer;

var
  Form1: TForm1;
  Time:Integer;
  TimeInt:Ttime;
  BeginTime:Integer;
  StartStop:boolean=True; //При запуске таймера меняется на False, при остановке на True
  IniFile, IniFileEvent: TIniFile; //Ini файлы для настроек программы
  Sound:String; //Звуковой Файл для воспроизведения
  Load:Boolean=False; //После загрузки приложения меняется на True
  MinSek:String;
implementation

uses Unit2, Unit3, Unit4, Unit5;

{$R *.dfm}

//Процедура создания ярлыка программы
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
var
  IObject:IUnknown;
  SLink:IShellLink;
  PFile:IPersistFile;
begin
  IObject:=CreateComObject(CLSID_ShellLink);
  SLink:=IObject as IShellLink;
  PFile:=IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), FALSE);
end;

//Процедура ввода времени в SpinEdit при загрузке программы
Procedure EnterTime;
var
  Time:string;
  chas:string;
  min:string;
begin
  if (Form1.SpinEdit2.Value=0) and (Form1.SpinEdit3.Value=0) then
  begin
    Time:=timetostr(now);
    chas:=copy(Time,1, pos(':',Time)-1);
    Form1.SpinEdit2.Text:=Chas;
    delete(Time,1, pos(':',Time));
    min:=copy(Time,1, pos(':',Time)-1);
    Form1.SpinEdit3.Text:=min;
  end;
end;

//Функция для определения секунд при установке в положение "Таймер"
Function TimeSek(Sek:integer; Min:Boolean):Integer;
Begin
  if Min then Result:=Sek else Result:=Sek*60;
End;

//Функция для определения оставшегося времени при установке в положение "Таймер"
Function OstalosTime(Min:Boolean):String;
Begin
  if Min then Result:=IntToStr(Time) else Result:=IntToStr(Round(Time/60));
End;

{Function TimeDiff(time1:ttime):integer;
Begin
Result:=MinutesBetween(gettime, time1)+1;
End;}

//Процедура сохранения настроек "Событие"
Procedure SaveEvent;
Begin
  IniFileEvent:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
  IniFileEvent.WriteString('Event','Text',Form1.Edit1.Text);
  if Form1.RadioButton3.Checked then IniFileEvent.WriteInteger('Event','Int',3);
  if Form1.RadioButton4.Checked then IniFileEvent.WriteInteger('Event','Int',2);
  if Form1.RadioButton5.Checked then IniFileEvent.WriteInteger('Event','Int',1);
  if Form1.RadioButton1.Checked
  then
  IniFileEvent.WriteBool('Event','Timer',True)
  else
  IniFileEvent.WriteBool('Event','Timer',False);
  IniFileEvent.WriteInteger('Event','Time',Form1.SpinEdit1.Value);
  IniFileEvent.WriteInteger('Event','Chas',Form1.SpinEdit2.Value);
  IniFileEvent.WriteInteger('Event','Minute',Form1.SpinEdit3.Value);
  IniFileEvent.WriteBool('Event','TimerCyclically',Form1.CheckBox1.Checked);
  IniFileEvent.WriteBool('Event','Sek',Form1.CheckBox2.Checked);
End;

//Процедура запуска таймера при установке в положение "Время"
Procedure Start;
Begin
  Time:=TimeSek(Form1.SpinEdit1.Value, Form1.CheckBox2.Checked);
  BeginTime:=Time;
  Form1.BitBtn2.Caption:='Остановить';
  Form1.N4.Caption:='Остановить';
  StartStop:=False;
  Form1.SpinEdit1.Enabled:=False;
  Form1.SpinEdit2.Enabled:=False;
  Form1.SpinEdit3.Enabled:=False;
  Form1.CheckBox2.Enabled:=False;
  Form1.RadioButton1.Enabled:=False;
  Form1.RadioButton2.Enabled:=False;
  if Form1.CheckBox2.Checked then
  begin
    Form5.Caption:='Секунд осталось';
    MinSek:=' (сек)';
    Form1.Label7.Caption:=MinSek;
  end
  else
  begin
    Form5.Caption:='Минут осталось';
    MinSek:=' (мин)';
    Form1.Label7.Caption:=MinSek;
  end;
  Form1.TrayIcon1.Hint:=Version+#13+'Времени осталось: '+IntToStr(Form1.SpinEdit1.Value)+MinSek;
  Form1.Label6.Caption:=IntToStr(Form1.SpinEdit1.Value);
  Form5.Label1.Caption:=IntToStr(Form1.SpinEdit1.Value);
  if Form4.CheckBox2.Checked then Form5.Show;
  Form1.Timer1.Enabled:=True;
  SaveEvent;
End;

//Функция для определения оставшегося времени при установке в положение "Время"
Function TimerTime(t1,t2:TTime):String;
Begin
  if t1>t2 then
  begin
    Result:=timetostr(t1-t2-StrToTime('00:00:01'));
    Exit;
  end;
  if t1<t2 then
  begin
    Result:=timetostr(strtotime('23:59:59')-t2+t1);
    Exit;
  end;
End;

//Процедура запуска таймера при установке в положение "Таймер"
Procedure StartInt;
Begin
  TimeInt:=encodetime(form1.SpinEdit2.Value, form1.SpinEdit3.Value, 0, 0);
  Form1.BitBtn2.Caption:='Остановить';
  Form1.N4.Caption:='Остановить';
  StartStop:=False;
  Form1.SpinEdit1.Enabled:=False;
  Form1.SpinEdit2.Enabled:=False;
  Form1.SpinEdit3.Enabled:=False;
  Form1.CheckBox2.Enabled:=False;
  Form1.RadioButton1.Enabled:=False;
  Form1.RadioButton2.Enabled:=False;
  Form1.Label6.Caption:=TimerTime(TimeInt,strtotime(timetostr(now)));
  Form5.Label1.Caption:=Form1.Label6.Caption;
  Form1.Label6.Caption:=TimerTime(TimeInt,strtotime(timetostr(now)));
  Form1.TrayIcon1.Hint:=Version+#13+'Времени осталось: '+Form1.Label6.Caption;
  Form1.Label7.Caption:=MinSek;
  if Form4.CheckBox2.Checked then Form5.Show;
  Form1.Timer2.Enabled:=True;
  Form5.Caption:='Времени осталось';
  SaveEvent;
End;

//Процедура остановки таймера при установленом параметре "Работать циклически"
Procedure StopOfTimer;
Begin
  Form1.BitBtn2.Caption:='Запустить';
  Form1.N4.Caption:='Запустить';
  StartStop:=True;
  Form1.MediaPlayer1.Close;
  Form1.SpinEdit1.Enabled:=True;
  Form1.SpinEdit2.Enabled:=True;
  Form1.SpinEdit3.Enabled:=True;
  Form1.CheckBox2.Enabled:=True;
  Form1.RadioButton1.Enabled:=True;
  Form1.RadioButton2.Enabled:=True;
  Form1.Timer1.Enabled:=False;
  Form2.Timer1.Enabled:=False;
  Form2.Timer2.Enabled:=False;
  Form1.Timer2.Enabled:=False;
  Form1.TrayIcon1.Hint:=Version;
  Form1.Label6.Caption:='';
  Form5.Label1.Caption:='';
  Form1.Label7.Caption:='';
  Form5.Hide;
  Form2.Hide;
  Form5.Caption:=Version;
  MinSek:='';
  if Form1.CheckBox1.Checked then
  begin
    if Form1.RadioButton1.Checked then Start;
    if Form1.RadioButton2.Checked then
    begin
      Sleep(600);
      StartInt;
    end;
  end;
End;

//Процедура остановки таймера
Procedure Stop;
Begin
  Form1.BitBtn2.Caption:='Запустить';
  Form1.N4.Caption:='Запустить';
  StartStop:=True;
  Form1.MediaPlayer1.Close;
  Form1.SpinEdit1.Enabled:=True;
  Form1.SpinEdit2.Enabled:=True;
  Form1.SpinEdit3.Enabled:=True;
  Form1.CheckBox2.Enabled:=True;
  Form1.RadioButton1.Enabled:=True;
  Form1.RadioButton2.Enabled:=True;
  Form1.Timer1.Enabled:=False;
  Form2.Timer1.Enabled:=False;
  Form2.Timer2.Enabled:=False;
  Form1.Timer2.Enabled:=False;
  Form1.TrayIcon1.Hint:=Version;
  Form1.Label6.Caption:='';
  Form5.Label1.Caption:='';
  Form1.Label7.Caption:='';
  Form5.Hide;
  Form2.Hide;
  Form5.Caption:=Version;
  MinSek:='';
end;

//Загрузка и установка параметров "Событие" при загрузке программы
Procedure InitEvent;
Begin
  IniFileEvent:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
  Form1.Edit1.Text:=IniFileEvent.ReadString('Event','Text','');
  Case IniFileEvent.ReadInteger('Event','Int',0) of
    1: Form1.RadioButton5.Checked:=True;
    2: begin
        Form1.RadioButton4.Checked:=True;
        Form1.OpenDialog2.FileName:=Form1.Edit1.Text;
       end;
    3: Form1.RadioButton3.Checked:=True;
  end;
  if IniFileEvent.ReadBool('Event','Timer',True)=true
  then Form1.RadioButton1.Checked:=True
  else Form1.RadioButton2.Checked:=True;
  Form1.SpinEdit1.Value:=IniFileEvent.ReadInteger('Event','Time',1);
  Form1.SpinEdit2.Value:=IniFileEvent.ReadInteger('Event','Chas',0);
  Form1.SpinEdit3.Value:=IniFileEvent.ReadInteger('Event','Minute',0);
  Form1.CheckBox1.Checked:=IniFileEvent.ReadBool('Event','TimerCyclically',False);
  Form1.CheckBox2.Checked:=IniFileEvent.ReadBool('Event','Sek',False);
End;

//Процедура зарузки настроек и параметров при загрузке программы
Procedure InitProg;
Begin
  IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
  Form4.CheckBox1.Checked:=IniFile.ReadBool('Settings','AlphaBlend',False);
  Form4.CheckBox2.Checked:=IniFile.ReadBool('Settings','ShowTime',False);
  Form4.CheckBox6.Checked:=IniFile.ReadBool('Settings','Adhesion',False);
  Form4.TrackBar1.Position:=IniFile.ReadInteger('Settings','AlphaBlendValue',0);
  Form4.TrackBar2.Position:=IniFile.ReadInteger('Settings','AlphaBlendValue5',0);
  If IniFile.ReadBool('Settings','Classic',False)=True then
  Begin
    Form1.Image1.Free;
    Form3.Image1.Free;
    Form4.Image1.Free;
    Form1.XPManifest1.Free;
    Form1.BalloonHint1.Free;
    Form4.CheckBox4.Checked:=true;
  End
  else form4.CheckBox4.Checked:=False;
  Form4.CheckBox7.Checked:=IniFile.ReadBool('Settings','ShowHint',False);
  Form4.CheckBox8.Checked:=IniFile.ReadBool('Settings','Over',False);
  Form4.CheckBox9.Checked:=IniFile.ReadBool('Settings','ShowPonelTasks',False);
  Form4.CheckBox10.Checked:=IniFile.ReadBool('Settings','Cyclically',False);
  Form4.CheckBox11.Checked:=IniFile.ReadBool('Settings','Volume',False);
  Form4.CheckBox12.Checked:=IniFile.ReadBool('Settings','Autolaunch',False);
  if IniFile.ReadBool('Settings','StartMin',False)=True then
  begin
    Form4.CheckBox5.Checked:=True;
    form1.WindowState:=wsMinimized;
    form1.Visible:=true;
  end
  else Form4.CheckBox5.Checked:=False;
  Sound:=IniFile.ReadString('Settings','Sound','');
  Form4.CheckBox3.Checked:=IniFile.ReadBool('Settings','AutoStart',False);
  Form1.Caption:=Version+' '+Form1.Caption;
  Form1.Label5.Caption:=TimeToStr(Now);
  Form1.Edit1.Text:=Version;
  Form5.Caption:=Version;
  Form3.Label11.Caption:=Form3.Label11.Caption+Version;
  MinSek:='';
  InitEvent;
  {EnterTime;} //Пока не использовать, но возможно пригодится
End;

//Процедура при минимизации приложения
procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  Form1.Hide;
end;

//Процедура выбора мелодии
procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if OpenDialog1.execute then
  begin
    Sound:=OpenDialog1.FileName;
    IniFile:=TIniFile.Create(ExtractFilePath(application.exename )+'Settings.ini');
    IniFile.WriteString('Settings','Sound',OpenDialog1.FileName);
  end;
end;

//Процедура нажатия на кнопку "Запустить"
procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  if RadioButton1.Checked then if StartStop then Start else Stop;
  if RadioButton2.Checked then if StartStop then StartInt else Stop;
end;

//Процедура вывода окна с настройками
procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

//Процедура показа плавающего окна
procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  If not StartStop then Form5.Show;
end;

//Процедура показа Окна "О программе"
procedure TForm1.Button3Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin

end;

//Процедура сворачивания окна вместо закрытия при щелчке на крестике
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caNone;
  Form1.Hide;
end;

//Процедура создания главного окна
procedure TForm1.FormCreate(Sender: TObject);
begin
  TrayIcon1.Hint:=Version;
  Application.Title:=Version;
end;

//Процедура при показе главного окна
procedure TForm1.FormShow(Sender: TObject);
begin
  if Form4.CheckBox9.Checked=true then ShowWindow(Application.Handle, sw_Hide)
  else ShowWindow(Application.Handle, sw_Show);
end;

//Процедура повторного воспроизведения звукового файла
procedure TForm1.MediaPlayer1Notify(Sender: TObject);
begin
  if Form4.CheckBox10.Checked and not StartStop  then
  begin
    Try
      with MediaPlayer1 do
      if NotifyValue = nvSuccessful then
      begin
        Notify := True;
        Play;
      end;
    Except
      Windows.Beep(2000, 1000);
    End;
  end;
end;

//Выход из программы
procedure TForm1.N1Click(Sender: TObject);
begin
  Application.Terminate;
end;

//Процедура запуска/остановки таймера из меню в трее
procedure TForm1.N4Click(Sender: TObject);
begin
  if StartStop then Start else Stop;
end;

//Процедура при нажатии на пареметр "Выключить компьютер"
procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  CheckBox1.Checked:=False;
  CheckBox1.Enabled:=False;
  Edit1.Text:='';
  Edit1.Enabled:=False;
end;

//Процедура при нажатии на пареметр "Запустить программу"
procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  CheckBox1.Enabled:=True;
  Edit1.Enabled:=False;
  if Load then
  begin
    if OpenDialog2.Execute then Edit1.Text:=OpenDialog2.FileName;
    Edit1.Text:=OpenDialog2.FileName;
  end;
end;

//Процедура при нажатии на пареметр "Сообщение"
procedure TForm1.RadioButton5Click(Sender: TObject);
begin
  CheckBox1.Enabled:=True;
  Edit1.Enabled:=True;
  Edit1.Text:='';
end;

//Процедура работы таймера при установленном параметре "Таймер"
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Dec(Time);
  If Time=0 then
  Begin
    if  RadioButton5.Checked then
    begin
      Timer1.Enabled:=False;
      Form2.Label1.Caption:=Form1.Edit1.Text;
      Form2.Timer2.Enabled:=True;
      Form2.Show;
      if not Form4.CheckBox11.Checked then
      begin
        Try
          Form1.MediaPlayer1.Close;
          Form1.MediaPlayer1.FileName:=Sound;
          Form1.MediaPlayer1.Open;
          Form1.MediaPlayer1.Play;
        Except
          Windows.Beep(2000, 1000);
        End;
      end;
      TrayIcon1.Hint:=Version+#13+'Времени осталось: '+OstalosTime(CheckBox2.Checked)+MinSek;
      Label6.Caption:=OstalosTime(CheckBox2.Checked);
      Form5.Close;
    end;
    if RadioButton3.Checked then
    begin
      ShellExecute(handle, nil,'shutdown',' -s -t 00','', SW_SHOWNORMAL);
      StopOfTimer;
    end;
    if RadioButton4.Checked then
    begin
      ShellExecute(Handle,'Open',Pchar(Edit1.Text),nil,nil,1);
      stopOfTimer;
    end;
  End
  else
  begin
    TrayIcon1.Hint:=Version+#13+'Времени осталось: '+OstalosTime(CheckBox2.Checked)+MinSek;
    Label6.Caption:=OstalosTime(CheckBox2.Checked);
    Form5.Label1.Caption:=OstalosTime(CheckBox2.Checked);
  end;
end;

//Процедура работы таймера при установленном параметре "Время"
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  If timetostr(TimeInt)=timetostr(GetTime) then
  Begin
    if RadioButton5.Checked then
    Begin
      Timer2.Enabled:=False;
      Form2.Label1.Caption:=Form1.Edit1.Text;
      Form2.Timer2.Enabled:=True;
      Timer2.Enabled:=False;
      Form2.Show;
      if not Form4.CheckBox11.Checked then
      begin
        Try
          Form1.MediaPlayer1.Close;
          Form1.MediaPlayer1.FileName:=Sound;
          Form1.MediaPlayer1.Open;
          Form1.MediaPlayer1.Play;
        Except
          Windows.Beep(2000, 1000);
        End;
      end;
      TrayIcon1.Hint:=Version+#13+'Времени осталось: '+Label6.Caption;
      Form5.Close;
    End;
    if RadioButton3.Checked then
    begin
      ShellExecute(handle, nil,'shutdown',' -s -t 00','', SW_SHOWNORMAL);
      StopOfTimer;
    end;
    if RadioButton4.Checked then
    begin
      ShellExecute(Handle,'Open',Pchar(Edit1.Text),nil,nil,1);
      StopOfTimer;
    end;
  End
  else
  begin
    Form1.Label6.Caption:=TimerTime(TimeInt,strtotime(timetostr(now)));
    TrayIcon1.Hint:=Version+#13+'Времени осталось: '+Label6.Caption;
    Form5.Label1.Caption:=Label6.Caption;
  end;
end;

//Процедура вывода времени на часы
procedure TForm1.Timer3Timer(Sender: TObject);
begin
  Label5.Caption:=TimeToStr(now);
end;

//Процедура при щелчке на иконке в трее (Показ главного окна)
procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Form1.Show;
  application.Restore;
  form1.WindowState:=WsNormal;
end;

end.
