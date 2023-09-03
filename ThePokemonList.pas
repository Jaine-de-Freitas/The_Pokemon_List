unit ThePokemonList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.JSON, System.Generics.Collections, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Imaging.GIFImg, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Image1: TImage;
    ListBox1: TListBox;
    Panel1: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Memo1: TMemo;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Image3: TImage;
    Button1: TButton;
    Image4: TImage;
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  jobj,jsub:TJSONObject;
  jAr:TJSONArray;
  jVl:TJSONValue;

  veAr:Integer;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
  var
    ints:Integer;
begin
  if(veAr=1) then
  begin
  ListBox1.Clear;
  for ints := 0 to  jAr.Count -1 do
      begin
        jsub := (jAr.Items[ints] as TJSONObject);
        jVl := jsub.Pairs[0].JsonValue;
        ListBox1.Items.Add(jVl.Value.ToUpper);
      end;
  end
  else
  begin
    try
      RESTClient1.BaseURL := 'https://pokeapi.co/api/v2/generation/1/';
      RESTRequest1.Execute;
      text := RESTRequest1.Response.JSONText;

      jobj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(text),0) as TJSONObject;
      jVl := jobj.Get('pokemon_species').JsonValue;
      jAr := jVl as TJSONArray;

      Form1.Caption:='The Pokémon List';

      for ints := 0 to  jAr.Count -1 do
      begin
        jsub := (jAr.Items[ints] as TJSONObject);
        jVl := jsub.Pairs[0].JsonValue;
        ListBox1.Items.Add(jVl.Value.ToUpper);
      end;
      veAr:=1;
    except
      ShowMessage('Algum problema com nossos pokémons! Clique em "Carregar lista padrão" para tentar novamente :)');
      veAr:=0;
    end;
  end;
  Form1.Caption:='The Pokémon List';
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  text:String;
  ints:Integer;
begin
try
  RESTClient1.BaseURL := 'https://pokeapi.co/api/v2/generation/1/';
  RESTRequest1.Execute;
  text := RESTRequest1.Response.JSONText;

  jobj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(text),0) as TJSONObject;
  jVl := jobj.Get('pokemon_species').JsonValue;
  jAr := jVl as TJSONArray;

  for ints := 0 to  jAr.Count -1 do
  begin
    jsub := (jAr.Items[ints] as TJSONObject);
    jVl := jsub.Pairs[0].JsonValue;
    ListBox1.Items.Add(jVl.Value.ToUpper);
  end;
  veAr:=1;
except
  ShowMessage('Algum problema com nossos pokémons! Clique em "Carregar lista padrão" para tentar novamente :)');
  veAr:=0;
end;
end;

procedure TForm1.Image1Click(Sender: TObject);
  var
  ints:Integer;
  texto:String;
  pNomeOf:TJSONValue;
  pNome:TJSONObject;
begin
  texto:=Edit1.Text;
  ListBox1.Clear;

  for ints := 0 to  jAr.Count -1 do
  begin
    pNome:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jAr.Items[ints].ToString),0) as TJSONObject;
    pNomeOf:=pNome.Get('name').JsonValue;

    if (pNomeOf.ToString.Replace('"','').Contains(texto.ToLower)) then
      begin
        ListBox1.Items.Add(pNomeOf.ToString.Replace('"','').ToUpper);
      end;
  end;
  if (ListBox1.Count < 1) then
    begin
      ShowMessage('Pokémon não encontrado! Feche esta janela ou clique em "OK" para voltar a lista inicial.');
      for ints := 0 to  jAr.Count -1 do
      begin
        jsub := (jAr.Items[ints] as TJSONObject);
        jVl := jsub.Pairs[0].JsonValue;
        ListBox1.Items.Add(jVl.Value.ToUpper);
      end;
    end;
end;

procedure TForm1.Image3Click(Sender: TObject);
  var
    ints:Integer;
begin
  ListBox1.Clear;
  for ints := 0 to  jAr.Count -1 do
      begin
        jsub := (jAr.Items[ints] as TJSONObject);
        jVl := jsub.Pairs[0].JsonValue;
        ListBox1.Items.Add(jVl.Value.ToUpper);
      end;
  ListBox1.Visible:=true;
  Panel1.Visible:=false;
  Button1.Visible:=true;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
    jobj2,jsub2,jsub3:TJSONObject;
    jAr2:TJSONArray;
    jVl2,jVl3,jVl4:TJSONValue;
    infor:String;
    ints:Integer;
    ids:Integer;
begin
  try
  if ListBox1.ItemIndex > -1 then
    begin
      Memo1.Clear;
      Label1.Caption:=(ListBox1.Items[ListBox1.ItemIndex]);

      ids:=ListBox1.ItemIndex+1;
      RESTClient1.BaseURL := 'https://pokeapi.co/api/v2/pokemon/'+ListBox1.Items[ListBox1.ItemIndex].ToLower+'/';
      RESTRequest1.Execute;
      infor := RESTRequest1.Response.JSONText;

      jobj2 := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(infor),0) as TJSONObject;
      jVl2 := jobj2.Get('abilities').JsonValue;
      jAr2 := jVl2 as TJSONArray;

      Memo1.Lines.Add('  HABILIDADES:');
      for ints := 0 to  jAr2.Count -1 do
        begin
          jsub2 := (jAr2.Items[ints] as TJSONObject);
          jVl3 := jsub2.Get('ability').JsonValue;
          jsub3:=jVl3 as TJSONObject;
          jVl4:=jsub3.Get('name').JsonValue;
          Memo1.Lines.Add('    '+jVl4.Value.ToUpper);
        end;

      jVl2 := jobj2.Get('height').JsonValue;
      Memo1.Lines.Add('  HEIGTH: '+jVl2.Value.ToUpper);

      jVl2 := jobj2.Get('base_experience').JsonValue;
      Memo1.Lines.Add('  EXPERIÊNCIA BASE: '+jVl2.Value.ToUpper);

      ListBox1.Visible:=false;
      Panel1.Visible:=true;
      Button1.Visible:=false;
    end;
  except
    ShowMessage('Tivemos alguns erros com nossos pokémons! Tente novamente :)');
  end;
end;

end.
