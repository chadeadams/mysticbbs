Unit bbs_cfg_EchoMail;

{$I M_OPS.PAS}

Interface

Uses
  BBS_Core,
  BBS_Common;

Function  Configuration_EchoMailNodes   (Edit: Boolean) : LongInt;
Function  Configuration_EchomailAddress (Edit: Boolean) : Byte;
Procedure Configuration_NodeExport      (Var MBase: RecMessageBase);

Implementation

Uses
  m_DateTime,
  m_Strings,
  m_FileIO,
  m_QuickSort,
  bbs_Ansi_MenuBox,
  bbs_Ansi_MenuForm,
  bbs_cfg_Common,
  bbs_Cfg_MsgBase;

Function IsExportNode (Var MBase: RecMessageBase; Idx: LongInt) : Boolean;
Var
  ExpFile : File of RecEchoMailExport;
  ExpNode : RecEchoMailExport;
Begin
  Result := False;

  Assign (ExpFile, MBase.Path + MBase.FileName + '.lnk');

  If Not ioReset (ExpFile, SizeOf(RecEchoMailExport), fmRWDN) Then Exit;

  While Not Eof(ExpFile) Do Begin
    Read (ExpFile, ExpNode);

    If ExpNode = Idx Then Begin
      Result := True;

      Break;
    End;
  End;

  Close (ExpFile);
End;

Procedure AddExportByBase (Var MBase: RecMessageBase; Idx: LongInt);
Var
  ExpFile : File of RecEchoMailExport;
Begin
  If IsExportNode (MBase, Idx) Then Exit;

  Assign (ExpFile, MBase.Path + MBase.FileName + '.lnk');

  If Not ioReset (ExpFile, SizeOf(RecEchoMailExport), fmRWDN) Then
    If Not ioReWrite (ExpFile, SizeOf(RecEchoMailExport), fmRWDN) Then
      Exit;

  Seek  (ExpFile, FileSize(ExpFile));
  Write (ExpFile, Idx);
  Close (ExpFile);
End;

Procedure RemoveExportFromBase (Var MBase: RecMessageBase; Idx: LongInt);
Var
  ExpFile : File of RecEchoMailExport;
  ExpNode : RecEchoMailExport;
Begin
  Assign (ExpFile, MBase.Path + MBase.FileName + '.lnk');

  If Not ioReset (ExpFile, SizeOf(RecEchoMailExport), fmRWDN) Then Exit;

  While Not Eof(ExpFile) Do Begin
    Read (ExpFile, ExpNode);

    If ExpNode = Idx Then
      KillRecord (ExpFile, FilePos(ExpFile), SizeOf(RecEchoMailExport));
  End;

  Close (ExpFile);
End;

Procedure RemoveExportGlobal (Idx: LongInt);
Var
  MBaseFile : File of RecMessageBase;
  MBase     : RecMessageBase;
Begin
  Assign (MBaseFile, Config.DataPath + 'mbases.dat');

  If Not ioReset(MBaseFile, SizeOf(RecMessageBase), fmRWDN) Then Exit;

  While Not Eof(MBaseFile) Do Begin
    Read (MBaseFile, MBase);

    RemoveExportFromBase(MBase, Idx);
  End;

  Close (MBaseFile);
End;

Function GetNodeByIndex (Num: LongInt; Var TempNode: RecEchoMailNode) : Boolean;
Var
  F : File;
Begin
  Result := False;

  Assign (F, Config.DataPath + 'echonode.dat');

  If Not ioReset(F, SizeOf(RecEchoMailNode), fmRWDN) Then Exit;

  While Not Eof(F) Do Begin
    ioRead(F, TempNode);

    If TempNode.Index = Num Then Begin
      Result := True;

      Break;
    End;
  End;

  Close (F);
End;

Procedure EditNode (Var Node: RecEchoMailNode);
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String;
Begin
  Topic := '|03(|09Echomail Node|03) |01-|09> |15';
  Box   := TAnsiMenuBox.Create;
  Form  := TAnsiMenuForm.Create;

  Box.Header := ' Index ' + strI2S(Node.Index) + ' ';

  Box.Open (14, 6, 66, 18);

  VerticalLine (29,  9, 12);
  VerticalLine (29, 14, 16);

  WriteXY (21, 8, 112, 'Address');

  Form.AddWord ('Z', ' Zone'       , 23,  9, 31,  9,  6,  5,  0, 65535, @Node.Address.Zone,  Topic + 'Network Zone');
  Form.AddWord ('N', ' Net'        , 24, 10, 31, 10,  5,  5,  0, 65535, @Node.Address.Net,   Topic + 'Network Net');
  Form.AddWord ('O', ' Node'       , 23, 11, 31, 11,  6,  5,  0, 65535, @Node.Address.Node,  Topic + 'Network Node');
  Form.AddWord ('P', ' Point'      , 22, 12, 31, 12,  7,  5,  0, 65535, @Node.Address.Point, Topic + 'Network Point');

  Form.AddBol  ('A', ' Active'     , 21, 14, 31, 14,  8,  3, @Node.Active, Topic + 'Is node active?');
  Form.AddStr  ('D', ' Description', 16, 15, 31, 15, 13, 35, 35, @Node.Description, Topic + 'Node description');
  Form.AddStr  ('R', ' Arc Type'   , 19, 16, 31, 16, 10,  4, 4, @Node.ArcType, Topic + 'Archive type for packets');

  Form.Execute;

  Box.Close;

  Form.Free;
  Box.Free;
End;

Procedure EditExportsByNode (Var Node: RecEchoMailNode);
Var
  Box       : TAnsiMenuBox;
  List      : TAnsiMenuList;
  MBaseFile : File of RecMessageBase;
  MBase     : RecMessageBase;

  Procedure MakeList;
  Begin
    List.Clear;

    Reset (MBaseFile);

    While Not Eof(MBaseFile) Do Begin
      Read (MBaseFile, MBase);

      If IsExportNode(MBase, Node.Index) Then
        List.Add(strPadR(strI2S(MBase.Index), 6, ' ') + ' ' + strPadR(strStripPipe(MBase.Name), 40, ' '), 0);
    End;
  End;

Var
  NewIdx : LongInt;
Begin
  Assign (MBaseFile, Config.DataPath + 'mbases.dat');

  If Not ioReset(MBaseFile, SizeOf(RecMessageBase), fmRWDN) Then
    Exit;

  Box  := TAnsiMenuBox.Create;
  List := TAnsiMenuList.Create;

  List.NoWindow := True;
  List.LoChars  := #27#47;
  List.SearchY  := 21;
  Box.Header    := ' Exports to ' + Node.Description + ' ';

  Box.Open (11, 5, 69, 21);

  WriteXY (13,  6, 112, 'Index  Base');
  WriteXY (13,  7, 112, strRep(#196, 55));
  WriteXY (13, 19, 112, strRep(#196, 55));
  WriteXY (29, 20, 112, cfgCommandList);

  Repeat
    MakeList;

    List.Open (11, 7, 69, 19);

    Case List.ExitCode of
      '/' : Case GetCommandOption(10, 'I-Insert|D-Delete|') of
              'I' : Begin
                      Close (MBaseFile);

                      NewIdx := Configuration_MessageBaseEditor(False);

                      If NewIdx <> -1 Then
                        If Session.Msgs.GetBaseByIndex(NewIdx, MBase) Then Begin
                          If MBase.EchoTag = '' Then
                            ShowMsgBox(0, 'Missing ECHOTAG for ' + strStripPipe(MBase.Name))
                          Else
                            AddExportByBase (MBase, Node.Index);
                        End;
                    End;
              'D' : If List.ListMax > 0 Then
                      If ShowMsgBox(1, 'Delete this entry?') Then
                        If Session.Msgs.GetBaseByIndex (strS2I(strWordGet(1, List.List[List.Picked]^.Name, ' ')), MBase) Then Begin

                        RemoveExportFromBase(MBase, Node.Index);
                      End;
            End;
      #27 : Break;
    End;
  Until False;

  List.Close;
  Box.Close;

  List.Free;
  Box.Free;

  Close (MBaseFile);
End;

Function Configuration_EchoMailNodes (Edit: Boolean) : LongInt;
Var
  Box      : TAnsiMenuBox;
  List     : TAnsiMenuList;
  EchoFile : File of RecEchoMailNode;
  EchoNode : RecEchoMailNode;

  Function GetPermanentIndex (Start: LongInt) : LongInt;
  Var
    TempNode : RecEchoMailNode;
    SavedRec : LongInt;
  Begin
    Result   := Start;
    SavedRec := FilePos(EchoFile);

    If Result = 0 Then Inc(Result);

    Reset (EchoFile);

    While Not Eof(EchoFile) Do Begin
      Read (EchoFile, TempNode);

      If Result = TempNode.Index Then Begin
        If Result >= 2000000 Then Result := 1;

        Inc   (Result);
        Reset (EchoFile);
      End;
    End;

    Seek (EchoFile, SavedRec);
  End;

  Procedure MakeList;
  Begin
    List.Clear;

    Reset (EchoFile);

    While Not Eof(EchoFile) Do Begin
      Read (EchoFile, EchoNode);

      List.Add(strPadR(strI2S(FilePos(EchoFile)), 3, ' ') + '  ' + strPadR(EchoNode.Description, 35, ' ') + ' ' + strPadL(strAddr2Str(EchoNode.Address), 12, ' '), 0);
    End;

    List.Add('', 2);
  End;

  Procedure InsertRecord;
  Begin
    AddRecord (EchoFile, List.Picked, SizeOf(RecEchoMailNode));

    FillChar (EchoNode, SizeOf(RecEchoMailNode), 0);

    With EchoNode Do Begin
      Description := 'New echomail node';
      Index       := GetPermanentIndex(FileSize(EchoFile));
    End;

    Write (EchoFile, EchoNode);
  End;

Begin
  Result := -1;

  Assign (EchoFile, Config.DataPath + 'echonode.dat');

  If Not ioReset(EchoFile, SizeOf(EchoNode), fmRWDN) Then
    If Not ioReWrite(EchoFile, SizeOf(EchoNode), fmRWDN) Then
      Exit;

  Box  := TAnsiMenuBox.Create;
  List := TAnsiMenuList.Create;

  List.NoWindow := True;
  List.LoChars  := #13#27#47;
  List.AllowTag := True;
  List.SearchY  := 21;

  Box.Header := ' EchoMail Nodes ';

  If Not Edit Then Box.Header := ' Select' + Box.Header;

  Box.Open (11, 5, 69, 21);

  WriteXY (13,  6, 112, '###  Node Description' + strRep(' ', 25) + 'Network');
  WriteXY (13,  7, 112, strRep(#196, 53));
  WriteXY (13, 19, 112, strRep(#196, 53));
  WriteXY (28, 20, 112, cfgCommandList);

  Repeat
    MakeList;

    List.Open (11, 7, 69, 19);
    List.Close;

    Case List.ExitCode of
      '/' : If Edit Then
            Case GetCommandOption(10, 'I-Insert|D-Delete|E-Exports|') of
              'I' : Begin
                      InsertRecord;
                      MakeList;
                    End;
              'D' : If (List.Picked < List.ListMax) Then
                      If ShowMsgBox(1, 'Delete this entry?') Then Begin
                        Seek (EchoFile, List.Picked - 1);
                        Read (EchoFile, EchoNode);

                        KillRecord (EchoFile, List.Picked, SizeOf(RecEchoMailNode));

                        RemoveExportGlobal(EchoNode.Index);

                        MakeList;
                      End;
               'E' : If List.Picked < List.ListMax Then Begin
                       Seek (EchoFile, List.Picked - 1);
                       Read (EchoFile, EchoNode);

                       EditExportsByNode(EchoNode);
                     End;
            End;
      #13 : If List.Picked < List.ListMax Then Begin
              Seek (EchoFile, List.Picked - 1);
              Read (EchoFile, EchoNode);

              If Not Edit Then Begin
                Result := EchoNode.Index;

                Break;
              End;

              EditNode(EchoNode);

              Seek  (EchoFile, List.Picked - 1);
              Write (EchoFile, EchoNode);
            End;
      #27 : Break;
    End;
  Until False;

  Close (EchoFile);

  Box.Close;
  List.Free;
  Box.Free;
End;

Function Configuration_EchomailAddress (Edit: Boolean) : Byte;

  Procedure EditAddress (Num: Byte);
  Var
    Box   : TAnsiMenuBox;
    Form  : TAnsiMenuForm;
    Topic : String;
  Begin
    Topic := '|03(|09Echomail Network|03) |01-|09> |15';
    Box   := TAnsiMenuBox.Create;
    Form  := TAnsiMenuForm.Create;

    Box.Open (14, 6, 66, 17);

    VerticalLine (29,  9, 12);
    VerticalLine (29, 14, 15);

    WriteXY (21, 8, 112, 'Address');

    Form.AddWord ('Z', ' Zone'       , 23,  9, 31,  9,  6,  5,  0, 65535, @Config.NetAddress[Num].Zone, Topic + 'Network Zone');
    Form.AddWord ('N', ' Net'        , 24, 10, 31, 10,  5,  5,  0, 65535, @Config.NetAddress[Num].Net, Topic + 'Network Net');
    Form.AddWord ('O', ' Node'       , 23, 11, 31, 11,  6,  5,  0, 65535, @Config.NetAddress[Num].Node, Topic + 'Network Node');
    Form.AddWord ('P', ' Point'      , 22, 12, 31, 12,  7,  5,  0, 65535, @Config.NetAddress[Num].Point, Topic + 'Network Point');

    Form.AddStr  ('M', ' Domain',      21, 14, 31, 14,  8,  8,  8, @Config.NetDomain[Num], Topic + 'Network domain');
    Form.AddStr  ('D', ' Description', 16, 15, 31, 15, 13, 25, 25, @Config.NetDesc[Num], Topic + 'Network description');

    Form.Execute;

    Box.Close;

    Form.Free;
    Box.Free;
  End;

Var
  Box  : TAnsiMenuBox;
  List : TAnsiMenuList;

  Procedure CreateList;
  Var
    A : Byte;
  Begin
    List.Clear;

    For A := 1 to 30 Do
      List.Add(strPadL(strAddr2Str(Config.NetAddress[A]), 23, ' ') + ' ' + strPadL(Config.NetDesc[A], 20, ' '), 0);
  End;

Begin
  Result := 0;

  Box  := TAnsiMenuBox.Create;
  List := TAnsiMenuList.Create;

  List.NoWindow := True;

  Box.Open (17, 5, 64, 20);

  WriteXY (27, 6, 112, 'Network Address          Description');
  WriteXY (19, 7, 112, strRep('�', 44));

  Repeat
    CreateList;

    List.Open (17, 7, 64, 20);

    Case List.ExitCode of
      #13 : If Edit Then
              EditAddress(List.Picked)
            Else Begin
              Result := List.Picked;
              Break;
            End;
      #27 : Break;
    End;
  Until False;

  List.Close;
  Box.Close;

  List.Free;
  Box.Free;
End;

Procedure Configuration_NodeExport (Var MBase: RecMessageBase);
Var
  ExportFile : File of RecEchoMailExport;
  ExpNode    : RecEchoMailExport;
  Box        : TAnsiMenuBox;
  List       : TAnsiMenuList;

  Procedure MakeList;
  Var
    Node : RecEchoMailNode;
  Begin
    List.Clear;

    Reset (ExportFile);

    While Not Eof(ExportFile) Do Begin
      Read (ExportFile, ExpNode);

      If GetNodeByIndex(ExpNode, Node) Then
        List.Add(strPadR(strI2S(FilePos(ExportFile)), 4, ' ') + ' ' + strPadR(Node.Description, 37, ' ') + ' ' + strPadL(strAddr2Str(Node.Address), 12, ' '), 0)
      Else
        List.Add('XXX  UNKNOWN - DELETE THIS', 0);
    End;
  End;

Var
  NewIdx : RecEchoMailExport;
Begin
  Assign (ExportFile, MBase.Path + MBase.FileName + '.lnk');

  If Not ioReset(ExportFile, SizeOf(RecEchoMailExport), fmRWDN) Then
    If Not ioReWrite(ExportFile, SizeOf(RecEchoMailExport), fmRWDN) Then
      Exit;

  Box  := TAnsiMenuBox.Create;
  List := TAnsiMenuList.Create;

  List.NoWindow := True;
  List.LoChars  := #27#47;
  List.SearchY  := 21;

  Box.Header := ' EchoMail Exports ';

  Box.Open (11, 5, 69, 21);

  WriteXY (13,  6, 112, '###  Description' + strRep(' ', 32) + 'Address');
  WriteXY (13,  7, 112, strRep(#196, 55));
  WriteXY (13, 19, 112, strRep(#196, 55));
  WriteXY (29, 20, 112, cfgCommandList);

  Repeat
    MakeList;

    List.Open (11, 7, 69, 19);

    Case List.ExitCode of
      '/' : Case GetCommandOption(10, 'I-Insert|D-Delete|') of
              'I' : Begin
                      NewIdx := Configuration_EchoMailNodes(False);

                      If (NewIdx > 0) And Not IsExportNode(MBase, NewIdx) Then Begin
                        Seek  (ExportFile, FileSize(ExportFile));
                        Write (ExportFile, NewIdx);
                      End;
                    End;
              'D' : If List.ListMax > 0 Then
                      If ShowMsgBox(1, 'Delete this entry?') Then
                        KillRecord (ExportFile, List.Picked, SizeOf(RecEchoMailExport));
            End;
      #27 : Break;
    End;
  Until False;

  List.Close;
  Box.Close;

  List.Free;
  Box.Free;

  Close (ExportFile);
End;

End.