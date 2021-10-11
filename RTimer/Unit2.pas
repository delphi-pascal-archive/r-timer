unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, GIFImg;

type
  TForm2 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
Form2.ClientWidth:=screen.Width;
end;

procedure TForm2.Label1Click(Sender: TObject);
begin
Timer1.Enabled:=False;
Timer2.Enabled:=False;
StopOfTimer;
Form2.close;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
Timer2.Enabled:=True;
Timer1.Enabled:=False;
Form2.AlphaBlendValue:=255;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
Timer1.Enabled:=True;
Timer2.Enabled:=False;
Form2.AlphaBlendValue:=50;
end;

procedure TForm2.FormClick(Sender: TObject);
begin
Timer1.Enabled:=False;
Timer2.Enabled:=False;
StopOfTimer;
Form2.close;
end;

end.
