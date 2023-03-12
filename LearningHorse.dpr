program LearningHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.Commons,
  System.JSON,
  System.SysUtils;

var
  Users: TJSONArray;

begin
  Users := TJSONArray.Create;
  THorse.Use(Jhonson());

  THorse.Get('/users',
  procedure(Req: THorseRequest; Res: THorseResponse)
  begin
    Res.Send<TJSONArray>(Users);
  end);

  THorse.Post('/users',
  procedure(Req: THorseRequest; Res: THorseResponse)
  var
    User: TJSONObject;
  begin
    User := Req.Body<TJSONObject>.Clone as TJSONObject;
    Users.AddElement(User);
    Res.Send<TJSONAncestor>(User.Clone).Status(THTTPStatus.Created);
  end);

  THorse.Delete('/users/:id',
  procedure(Req: THorseRequest; Res: THorseResponse)
  var
    Id: Integer;
  begin
    Id := Req.Params.Items['id'].ToInteger;
    Users.Remove(Pred(Id)).Free;
    Res.Send<TJSONAncestor>(Users.Clone).Status(THTTPStatus.NoContent);
  end);

  THorse.Listen(9000);
end.
