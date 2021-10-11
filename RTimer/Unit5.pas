unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit4;

{$R *.dfm}

procedure TForm5.FormPaint(Sender: TObject);
begin
If Form4.CheckBox8.checked then application.RestoreTopMosts;
end;

end.
