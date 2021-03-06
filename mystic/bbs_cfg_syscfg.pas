Unit bbs_cfg_syscfg;

// ====================================================================
// Mystic BBS Software               Copyright 1997-2013 By James Coyle
// ====================================================================
//
// This file is part of Mystic BBS.
//
// Mystic BBS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Mystic BBS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Mystic BBS.  If not, see <http://www.gnu.org/licenses/>.
//
// ====================================================================

{$I M_OPS.PAS}

Interface

Procedure Configuration_SysPaths;
Procedure Configuration_GeneralSettings;
Procedure Configuration_LoginMatrix;
Procedure Configuration_OptionalFields;
Procedure Configuration_FileSettings;
Procedure Configuration_QWKSettings;
Procedure Configuration_Internet;
Procedure Configuration_FTPServer;
Procedure Configuration_TelnetServer;
Procedure Configuration_POP3Server;
Procedure Configuration_SMTPServer;
Procedure Configuration_NNTPServer;
Procedure Configuration_BINKPServer;
Procedure Configuration_MessageSettings;
Procedure Configuration_NewUser1Settings;
Procedure Configuration_NewUser2Settings;
Procedure Configuration_ConsoleSettings;

Implementation

Uses
  m_Strings,
  BBS_Records,
  BBS_DataBase,
  BBS_Ansi_MenuBox,
  BBS_Ansi_MenuForm;

Procedure Configuration_SysPaths;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09System Paths|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' System Directories ';

  Box.Open (5, 6, 75, 20);

  VerticalLine (26, 8, 18);

  Form.AddPath ('S', ' System Path',       13,  8, 28,  8, 13, 45, mysMaxPathSize, @bbsCfg.SystemPath,   Topic + 'Root Mystic BBS directory');
  Form.AddPath ('D', ' Data File Path',    10,  9, 28,  9, 16, 45, mysMaxPathSize, @bbsCfg.DataPath,     Topic + 'Data file directory');
  Form.AddPath ('L', ' Log File Path',     11, 10, 28, 10, 15, 45, mysMaxPathSize, @bbsCfg.LogsPath,     Topic + 'Log file directory');
  Form.AddPath ('M', ' Message Base Path',  7, 11, 28, 11, 19, 45, mysMaxPathSize, @bbsCfg.MsgsPath,     Topic + 'Message base directory');
  Form.AddPath ('A', ' File Attach Path',   8, 12, 28, 12, 18, 45, mysMaxPathSize, @bbsCfg.AttachPath,   Topic + 'File attachment directory');
  Form.AddPath ('E', ' Semaphore Path',    10, 13, 28, 13, 16, 45, mysMaxPathSize, @bbsCfg.SemaPath,     Topic + 'Semaphore file directory');
  Form.AddPath ('U', ' Menu File Path',    10, 14, 28, 14, 16, 45, mysMaxPathSize, @bbsCfg.MenuPath,     Topic + 'Default menu file directory');
  Form.AddPath ('T', ' Text File Path',    10, 15, 28, 15, 16, 45, mysMaxPathSize, @bbsCfg.TextPath,     Topic + 'Default display file directory');
  Form.AddPath ('R', ' Script Path',       13, 16, 28, 16, 13, 45, mysMaxPathSize, @bbsCfg.ScriptPath,   Topic + 'Default script (MPL) directory');
  Form.AddPath ('I', ' Inbound EchoMail',   8, 17, 28, 17, 18, 45, mysMaxPathSize, @bbsCfg.InboundPath,  Topic + 'Inbound Echomail directory');
  Form.AddPath ('O', ' Outbound EchoMail',  7, 18, 28, 18, 19, 45, mysMaxPathSize, @bbsCfg.OutboundPath, Topic + 'Outbound Echomail directory');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_GeneralSettings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09General Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' General Settings ';

  Box.Open (5, 5, 75, 19);

  VerticalLine (24, 7, 17);
  VerticalLine (67, 7, 12);

  Form.AddStr  ('B', ' BBS Name',         14,  7, 26,  7, 10, 25, 30, @bbsCfg.BBSName, Topic);
  Form.AddStr  ('S', ' Sysop Name',       12,  8, 26,  8, 12, 25, 30, @bbsCfg.SysopName, Topic);
  Form.AddPass ('Y', ' Sysop Password',    8,  9, 26,  9, 16, 15, 15, @bbsCfg.SysopPW, Topic);
  Form.AddPass ('T', ' System Password',   7, 10, 26, 10, 17, 15, 15, @bbsCfg.SystemPW, Topic);
  Form.AddStr  ('O', ' Sysop ACS',        13, 11, 26, 11, 11, 25, 30, @bbsCfg.ACSSysop, Topic);
  Form.AddStr  ('F', ' Feedback To',      11, 12, 26, 12, 13, 25, 30, @bbsCfg.FeedbackTo, Topic);
  Form.AddStr  ('A', ' Start Menu',       12, 13, 26, 13, 12, 20, 20, @bbsCfg.DefStartMenu, Topic);
  Form.AddStr  ('Q', ' QWK Net Menu',     10, 14, 26, 14, 14, 20, 20, @bbsCfg.QwkNetMenu, Topic + 'QWK menu for QWK network users');
  Form.AddStr  ('H', ' Theme',            17, 15, 26, 15,  7, 20, 20, @bbsCfg.DefThemeFile, Topic);
  Form.AddBol  ('K', ' Ask Theme',        13, 16, 26, 16, 11,  3, @bbsCfg.ThemeOnStart, Topic + 'Ask theme each connection');
  Form.AddTog  ('E', ' Terminal',         14, 17, 26, 17, 10, 10, 0, 3, 'Ask Detect Detect/Ask ANSI', @bbsCfg.DefTermMode, Topic);

  Form.AddBol  ('L', ' Chat Logging',     53,  7, 69,  7, 14,  3, @bbsCfg.ChatLogging, Topic);
  Form.AddByte ('R', ' Hours Start',      54,  8, 69,  8, 13,  2, 0, 24, @bbsCfg.ChatStart, Topic);
  Form.AddByte ('N', ' Hours End',        56,  9, 69,  9, 11,  2, 0, 24, @bbsCfg.ChatEnd, Topic);
  Form.AddBol  ('D', ' Chat Feedback',    52, 10, 69, 10, 15,  3, @bbsCfg.ChatFeedback, Topic);
  Form.AddByte ('Z', ' Screen Size',      54, 11, 69, 11, 13,  2, 1, 25, @bbsCfg.DefScreenSize, Topic);
  Form.AddWord ('I', ' Inactivity',       55, 12, 69, 12, 12,  5, 0, 65535, @bbsCfg.Inactivity, Topic + 'Inactivity timeout (seconds) 0/Disable');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_LoginMatrix;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09Login/Matrix|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Login/Matrix ';

  Box.Open (12, 6, 68, 20);

  VerticalLine (35, 7, 19);

  Form.AddByte ('A', ' Login Attempts',      19,  7, 37,  7, 16,  3,  1, 255,   @bbsCfg.LoginAttempts,  Topic + 'Maximum login attempts before disconnect');
  Form.AddByte ('T', ' Login Time',          23,  8, 37,  8, 12,  3,  1, 255,   @bbsCfg.LoginTime,      Topic + 'Max time in minutes to give for user login');
  Form.AddWord ('C', ' Password Change',     18,  9, 37,  9, 17,  5,  0, 65535, @bbsCfg.PWChange,       Topic + 'Days before forcing PW change (0/Disabled)');
  Form.AddBol  ('I', ' Password Inquiry',    17, 10, 37, 10, 18,  3,            @bbsCfg.PWInquiry,      Topic + 'Allow password inquiry e-mails?');
  Form.AddByte ('W', ' Password Attempts',   16, 11, 37, 11, 19,  2,  1, 99,    @bbsCfg.PWAttempts,     Topic + 'Max Password attempts');
  Form.AddTog  ('O', ' Start Code Page',     18, 12, 37, 12, 17,  5,  0, 1, 'CP437 UTF-8', @bbsCfg.StartCodePage, Topic + 'Logging in user''s code page');
  Form.AddBol  ('U', ' Use Matrix Login',    17, 13, 37, 13, 18,  3,            @bbsCfg.UseMatrix,      Topic + 'Use Matrix login menu?');
  Form.AddStr  ('M', ' Matrix Menu',         22, 14, 37, 14, 13, 20, 20,        @bbsCfg.MatrixMenu,     Topic + 'Matrix menu file name');
  Form.AddPass ('P', ' Matrix Password',     18, 15, 37, 15, 17, 15, 15,        @bbsCfg.MatrixPW,       Topic + 'Matrix password to login (Blank/Disabled)');
  Form.AddStr  ('S', ' Matrix ACS',          23, 16, 37, 16, 12, 30, 30,        @bbsCfg.MatrixACS,      Topic + 'ACS to see matrix password or login');
  Form.AddStr  ('V', ' Invisible Login ACS', 14, 17, 37, 17, 21, 30, 30,        @bbsCfg.AcsInvisLogin,  Topic + 'ACS to login as invisible user');
  Form.AddStr  ('N', ' See Invisible ACS',   16, 18, 37, 18, 19, 30, 30,        @bbsCfg.AcsSeeInvis,    Topic + 'ACS to see invisible users');
  Form.AddStr  ('L', ' Multi Login ACS',     18, 19, 37, 19, 17, 30, 30,        @bbsCfg.AcsMultiLogin,  Topic + 'ACS to login to multiple nodes at once');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_OptionalFields;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String;
  Count : Byte;
Begin
  Topic := '|03(|09Optional Fields|03) |01-|09> |15';
  Box   := TAnsiMenuBox.Create;
  Form  := TAnsiMenuForm.Create;

  Box.Header := ' Optional User Fields ';

  For Count := 1 to 10 Do Begin
    Form.AddBol  ('1', 'Ask' ,   8, 7 + Count, 12, 7 + Count, 3, 3,      @bbsCfg.OptionalField[Count].Ask, Topic + 'Ask optional field #' + strI2S(Count));
    Form.AddStr  ('2', 'Desc',  18, 7 + Count, 23, 7 + Count, 4, 13, 13, @bbsCfg.OptionalField[Count].Desc, Topic + 'Description of field (for user editor)');
    Form.AddTog  ('3', 'Type',  41, 7 + Count, 46, 7 + Count, 4, 8, 1, 8, 'Standard Upper Proper Phone Date Password Lower Yes/No', @bbsCfg.OptionalField[Count].iType, Topic + 'Field input type');
    Form.AddByte ('4', 'Field', 57, 7 + Count, 63, 7 + Count, 5, 2, 1, 60, @bbsCfg.OptionalField[Count].iField, Topic + 'Size of input field');
    Form.AddByte ('5', 'Max'  , 68, 7 + Count, 72, 7 + Count, 3, 2, 1, 60, @bbsCfg.OptionalField[Count].iMax, Topic + 'Maximum size of input');
  End;

  Box.Open (6, 6, 75, 19);

  Form.Execute;

  Box.Close;
  Form.Free;
  Box.Free;
End;

Procedure Configuration_FileSettings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09File Base Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' File Base Settings ';

  Box.Open (5, 5, 76, 21);

  VerticalLine (26, 7, 19);
  VerticalLine (58, 7, 15);

  Form.AddBol  ('L', ' List Compression',    8,  7, 28,  7, 18,  3, @bbsCfg.FCompress, Topic + '');
  Form.AddTog  ('I', ' List Columns',       12,  8, 28,  8, 14,  1, 1, 2, '1 2', @bbsCfg.FColumns, Topic + '');
  Form.AddBol  ('B', ' Bases in Groups',     9,  9, 28,  9, 17,  3, @bbsCfg.FShowBases, Topic + '');
  Form.AddBol  ('R', ' Reshow File Header',  6, 10, 28, 10, 20,  3, @bbsCfg.FShowHeader, Topic + '');
  Form.AddTog  ('U', ' Upload Dupe Scan',    8, 11, 28, 11, 18,  7, 0, 2, 'None Current All', @bbsCfg.FDupeScan, Topic + '');
  Form.AddWord ('P', ' Upload Base',        13, 12, 28, 12, 13,  5, 0, 65535, @bbsCfg.UploadBase, Topic + '');
  Form.AddByte ('D', ' Description Lines',   7, 13, 28, 13, 19,  2, 1, 99, @bbsCfg.MaxFileDesc, Topic + '');
  Form.AddBol  ('I', ' Import FILE_ID.DIZ',  6, 14, 28, 14, 20,  3, @bbsCfg.ImportDIZ, Topic + '');
  Form.AddByte ('M', ' Max Comment Lines',   7, 15, 28, 15, 19,  2, 1, 99, @bbsCfg.FCommentLines, Topic + '');
  Form.AddByte ('A', ' Max Comment Cols',    8, 16, 28, 16, 18,  2, 1, 79, @bbsCfg.FCommentLen, Topic + '');
  Form.AddBol  ('T', ' Test Uploads',       12, 17, 28, 17, 14,  3, @bbsCfg.TestUploads, Topic + '');
  Form.AddByte ('S', ' Pass Level',         14, 18, 28, 18, 12,  3, 0, 255, @bbsCfg.TestPassLevel, Topic + '');
  Form.AddStr  ('O', ' Command Line',       12, 19, 28, 19, 14, 45, 80, @bbsCfg.TestCmdLine, Topic + '');

  Form.AddStr  ('U', ' Auto Validate',      43,  7, 60,  7, 15, 15, mysMaxAcsSize, @bbsCfg.AcsValidate, Topic + 'ACS to auto-validate uploads');
  Form.AddStr  ('E', ' See Unvalidated',    41,  8, 60,  8, 17, 15, mysMaxAcsSize, @bbsCfg.AcsSeeUnvalid, Topic + 'ACS to see unvalidated files');
  Form.AddStr  ('N', ' DL Unvalidated',     42,  9, 60,  9, 16, 15, mysMaxAcsSize, @bbsCfg.AcsDLUnvalid, Topic + 'ACS to download unvalidated files');
  Form.AddStr  ('F', ' See Failed',         46, 10, 60, 10, 12, 15, mysMaxAcsSize, @bbsCfg.AcsSeeFailed, Topic + 'ACS to see failed files');
  Form.AddStr  (#0,  ' DL Failed',          47, 11, 60, 11, 11, 15, mysMaxAcsSize, @bbsCfg.AcsDLFailed, Topic + 'ACS to download failed files');
  Form.AddStr  (#0,  ' See Offline',        45, 12, 60, 12, 13, 15, mysMaxAcsSize, @bbsCfg.AcsSeeOffline, Topic + 'ACS to see offline files');
  Form.AddLong ('C', ' Min Upload Space',   40, 13, 60, 13, 18,  9, 0, 999999999, @bbsCfg.FreeUL, Topic + 'Min space to allow uploads (kb)');
  Form.AddLong ('-', ' Min CD-ROM Space',   40, 14, 60, 14, 18,  9, 0, 999999999, @bbsCfg.FreeCDROM, Topic + 'Min space for CD-ROM copy (kb)');
  Form.AddChar (#0,  ' Default Protocol',   40, 15, 60, 15, 18,  32, 96, @bbsCfg.FProtocol, Topic + 'Default Protocol hotkey');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_QWKSettings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09Offline Mail|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Offline Mail ';

  Box.Open (8, 7, 74, 18);

  VerticalLine (31, 9, 16);

  Form.AddPath ('L', ' Local QWK Path',         15,  9, 33,  9, 16, 40, mysMaxPathSize,        @bbsCfg.QWKPath,     Topic + 'Directory for local QWK packets');
  Form.AddStr  ('I', ' QWK Packet ID',          16, 10, 33, 10, 15,  8, 8, @bbsCfg.QwkBBSID, Topic + 'QWK packet filename');
  Form.AddStr  ('A', ' QWK Archive',            18, 11, 33, 11, 13,  4, 4, @bbsCfg.QwkArchive, Topic + 'QWK Archive');
  Form.AddWord ('P', ' Max Messages/Packet',    10, 12, 33, 12, 21,  5, 0, 65535, @bbsCfg.QwkMaxPacket, Topic + 'Max messages per packet (0/Unlimited)');
  Form.AddWord ('B', ' Max Messages/Base',      12, 13, 33, 13, 19,  5, 0, 65535, @bbsCfg.QwkMaxBase, Topic + 'Max message per base (0/Unlimited)');
  Form.AddStr  ('W', ' Welcome File',           17, 14, 33, 14, 14, 40, mysMaxPathSize, @bbsCfg.QWKWelcome, Topic + 'Welcome filename');
  Form.AddStr  ('N', ' News File',              20, 15, 33, 15, 11, 40, mysMaxPathSize, @bbsCfg.QWKNews, Topic + 'New filename');
  Form.AddStr  ('G', ' Goodbye File',           17, 16, 33, 16, 14, 40, mysMaxPathSize, @bbsCfg.QWKGoodbye, Topic + 'Goodbye filename');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_Internet;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09Internet Servers|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Internet Servers ';

  Box.Open (16, 9, 64, 16);

  VerticalLine (31, 11, 14);

  Form.AddStr  ('D', ' Domain',          23, 11, 33, 11,  8, 25, 25, @bbsCfg.inetDomain, Topic + 'Internet domain name');
  Form.AddStr  ('I', ' Interface',       20, 12, 33, 12, 11, 23, 23, @bbsCfg.inetInterface, Topic + 'Network interface IP address');
  Form.AddBol  ('B', ' IP Blocking',     18, 13, 33, 13, 13, 3, @bbsCfg.inetIPBlocking, Topic + 'Enable IP blocking');
  Form.AddBol  ('L', ' Logging',         22, 14, 33, 14,  9, 3, @bbsCfg.inetLogging, Topic + 'Enable server logging');

  Form.Execute;

  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_FTPServer;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09FTP Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' FTP Server ';

  Box.Open (26, 7, 55, 19);

  VerticalLine (47, 9, 17);

  Form.AddBol  ('U', ' Use FTP Server',     31,  9, 49,  9, 16,  3, @bbsCfg.inetFTPUse, Topic + 'Enable FTP server');
  Form.AddWord ('P', ' Server Port',        34, 10, 49, 10, 13,  5, 0, 65535, @bbsCfg.inetFTPPort, Topic + 'FTP Server port');
  Form.AddWord ('M', ' Max Connections',    30, 11, 49, 11, 17,  5, 0, 65535, @bbsCfg.inetFTPMax, Topic + 'Max concurrent connections');
  Form.AddWord ('C', ' Connection Timeout', 27, 12, 49, 12, 20,  5, 0, 65535, @bbsCfg.inetFTPTimeout, Topic + 'Connection timeout (seconds)');
  Form.AddByte ('D', ' Dupe IP Limit',      32, 13, 49, 13, 15,  3, 2, 255,   @bbsCfg.inetFTPDupes, Topic + 'Max connections with same IP');
  Form.AddWord ('I', ' Data Port Min',      32, 14, 49, 14, 15,  5, 0, 65535, @bbsCfg.inetFTPPortMin, Topic + 'Passive port range (minimum)');
  Form.AddWord ('A', ' Data Port Max',      32, 15, 49, 15, 15,  5, 0, 65535, @bbsCfg.inetFTPPortMax, Topic + 'Passive port range (maximum)');
  Form.AddBol  ('Y', ' Allow Passive',      32, 16, 49, 16, 15,  3, @bbsCfg.inetFTPPassive, Topic + 'Allow passive data transfers');
  Form.AddBol  ('Q', ' Hide User QWK',      31, 17, 49, 17, 15,  3, @bbsCfg.inetFTPHideQWK, Topic + 'Hide QWK packets in listings');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_TelnetServer;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09Telnet Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Telnet Server ';

  Box.Open (26, 9, 54, 17);

  VerticalLine (46, 11, 15);

  Form.AddBol  ('U', ' Use Telnet Server',  27, 11, 48, 11, 19, 3, @bbsCfg.inetTNUse, Topic + 'Enable Telnet server');
  Form.AddByte ('N', ' Telnet Nodes',       32, 12, 48, 12, 14, 3, 1, 255, @bbsCfg.inetTNNodes, Topic + 'Max telnet nodes to allow');
  Form.AddWord ('P', ' Server Port',        33, 13, 48, 13, 13, 5, 0, 65535, @bbsCfg.inetTNPort, Topic + 'Telnet Server port');
  Form.AddByte ('D', ' Dupe IP Limit',      31, 14, 48, 14, 15, 3, 1, 255,   @bbsCfg.inetTNDupes, Topic + 'Max connections with same IP');
  Form.AddBol  ('S', ' Start Hidden',       32, 15, 48, 15, 14, 3, @bbsCfg.inetTNHidden, Topic + 'Hide node windows (Windows)');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_POP3Server;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09POP3 Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' POP3 Server ';

  Box.Open (27, 8, 53, 17);

  VerticalLine (45, 10, 15);

  Form.AddBol  ('U', ' Use Server',      33, 10, 47, 10, 12, 3, @bbsCfg.inetPOP3Use, Topic + 'Enable POP3 server');
  Form.AddWord ('P', ' Server Port',     32, 11, 47, 11, 13, 5, 0, 65535, @bbsCfg.inetPOP3Port, Topic + 'POP3 Server port');
  Form.AddByte ('N', ' Max Connections', 28, 12, 47, 12, 17, 3, 1, 255, @bbsCfg.inetPOP3Max, Topic + 'Max Connections');
  Form.AddByte ('I', ' Dupe IP Limit',   30, 13, 47, 13, 15, 3, 1, 255,   @bbsCfg.inetPOP3Dupes, Topic + 'Max connections with same IP');
  Form.AddWord ('T', ' Timeout',         36, 14, 47, 14,  9, 5, 0, 65535, @bbsCfg.inetPOP3Timeout, Topic + 'Connection timeout (seconds)');
  Form.AddBol  ('D', ' Delete',          37, 15, 47, 15,  8, 3, @bbsCfg.inetPOP3Delete, Topic + 'Delete email on retreive');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_BINKPServer;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09BINKP Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' BINKP Server ';

  Box.Open (27, 8, 53, 17);

  VerticalLine (45, 10, 15);

  Form.AddBol  ('U', ' Use Server',      33, 10, 47, 10, 12, 3, @bbsCfg.inetBINKPUse, Topic + 'Enable BINKP server');
  Form.AddWord ('P', ' Server Port',     32, 11, 47, 11, 13, 5, 0, 65535, @bbsCfg.inetBINKPPort, Topic + 'BINKP Server port');
  Form.AddByte ('N', ' Max Connections', 28, 12, 47, 12, 17, 3, 1, 255, @bbsCfg.inetBINKPMax, Topic + 'Max Connections');
  Form.AddByte ('I', ' Dupe IP Limit',   30, 13, 47, 13, 15, 3, 1, 255,   @bbsCfg.inetBINKPDupes, Topic + 'Max connections with same IP');
  Form.AddWord ('T', ' Timeout',         36, 14, 47, 14,  9, 5, 0, 65535, @bbsCfg.inetBINKPTimeout, Topic + 'Connection timeout (seconds)');
  Form.AddBol  ('F', ' Force CRAM-MD5',  29, 15, 47, 15, 16, 3, @bbsCfg.inetBINKPCram5, Topic + 'Force CRAM-MD5 auth');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_SMTPServer;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09SMTP Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' SMTP Server ';

  Box.Open (27, 8, 53, 16);

  VerticalLine (45, 10, 14);

  Form.AddBol  ('U', ' Use Server',      33, 10, 47, 10, 12, 3, @bbsCfg.inetSMTPUse, Topic + 'Enable SMTP server');
  Form.AddWord ('P', ' Server Port',     32, 11, 47, 11, 13, 5, 0, 65535, @bbsCfg.inetSMTPPort, Topic + 'Server port');
  Form.AddByte ('N', ' Max Connections', 28, 12, 47, 12, 17, 3, 1, 255, @bbsCfg.inetSMTPMax, Topic + 'Max Connections');
  Form.AddByte ('I', ' Dupe IP Limit',   30, 13, 47, 13, 15, 3, 1, 255,   @bbsCfg.inetSMTPDupes, Topic + 'Max connections with same IP');
  Form.AddWord ('T', ' Timeout',         36, 14, 47, 14,  9, 5, 0, 65535, @bbsCfg.inetSMTPTimeout, Topic + 'Connection timeout (seconds)');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_NNTPServer;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09NNTP Server|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' NNTP Server ';

  Box.Open (27, 8, 53, 16);

  VerticalLine (45, 10, 14);

  Form.AddBol  ('U', ' Use Server',      33, 10, 47, 10, 12, 3, @bbsCfg.inetNNTPUse, Topic + 'Enable NNTP server');
  Form.AddWord ('P', ' Server Port',     32, 11, 47, 11, 13, 5, 0, 65535, @bbsCfg.inetNNTPPort, Topic + 'Server port');
  Form.AddByte ('N', ' Max Connections', 28, 12, 47, 12, 17, 3, 1, 255, @bbsCfg.inetNNTPMax, Topic + 'Max Connections');
  Form.AddByte ('I', ' Dupe IP Limit',   30, 13, 47, 13, 15, 3, 1, 255,   @bbsCfg.inetNNTPDupes, Topic + 'Max connections with same IP');
  Form.AddWord ('T', ' Timeout',         36, 14, 47, 14,  9, 5, 0, 65535, @bbsCfg.inetNNTPTimeout, Topic + 'Connection timeout (seconds)');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_MessageSettings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09Message Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Message Base Settings ';

  Box.Open (4, 5, 77, 19);

  VerticalLine (27, 7, 17);
  VerticalLine (65, 7, 14);

  Form.AddBol  ('C', ' List Compression',      9,  7, 29,  7, 18, 3, @bbsCfg.MCompress, Topic + 'Compress numbers in area list?');
  Form.AddByte ('I', ' List Columns',         13,  8, 29,  8, 14, 3, 1, 2, @bbsCfg.MColumns, Topic + 'Columns in area list');
  Form.AddBol  ('S', ' Show Message Header',   6,  9, 29,  9, 21, 3, @bbsCfg.MShowHeader, Topic + 'Redisplay header after each page');
  Form.AddBol  ('B', ' Bases in Group List',   6, 10, 29, 10, 21, 3, @bbsCfg.MShowBases, Topic + 'Calculate bases in group list?');
  Form.AddByte ('X', ' Max AutoSig Lines',     8, 11, 29, 11, 19, 3, 1, 99, @bbsCfg.MaxAutoSig, Topic + 'Max autosig lines');
  Form.AddBol  ('S', ' Force NL Match',       11, 12, 29, 12, 16, 3, @bbsCfg.ForceNodeList, Topic + 'Force nodelist lookup match when sending netmail?');
  Form.AddStr  ('R', ' Ext Reply ACS',        12, 13, 29, 13, 15, 20, 30, @bbsCfg.AcsExtReply, Topic + 'ACS: Allow users to select reply base');
  Form.AddStr  ('A', ' Attachment ACS',       11, 14, 29, 14, 16, 20, 30, @bbsCfg.AcsFileAttach, Topic + 'ACS: Allow file attachments');
  Form.AddBol  ('T', ' External FSE',         13, 15, 29, 15, 14, 3, @bbsCfg.FSEditor, Topic + 'Use external editor');
  Form.AddStr  ('F', ' FSE Command Line',      9, 16, 29, 16, 18, 40, 60, @bbsCfg.FSCommand, Topic + 'FSE command line');
  Form.AddStr  ('D', ' Default Origin',       11, 17, 29, 17, 16, 40, 50, @bbsCfg.Origin, Topic + 'Origin line for new bases');
//  Form.AddStr  ('2', ' Default Domain',       11, 18, 29, 18, 16,  8,  8, @bbsCfg.DefDomain, Topic + 'Default echomail domain');

  Form.AddAttr ('Q', ' Quote Color',          52,  7, 67,  7, 13, @bbsCfg.ColorQuote, Topic + 'Color for quoted text');
  Form.AddAttr ('E', ' Text Color'  ,         53,  8, 67,  8, 12, @bbsCfg.ColorText, Topic + 'Color for message text');
  Form.AddAttr ('O', ' Tear Color'  ,         53,  9, 67,  9, 12, @bbsCfg.ColorTear, Topic + 'Color for tear line');
  Form.AddAttr ('L', ' Origin Color',         51, 10, 67, 10, 14, @bbsCfg.ColorOrigin, Topic + 'Color for origin line');
  Form.AddAttr ('K', ' Kludge Color',         51, 11, 67, 11, 14, @bbsCfg.ColorKludge, Topic + 'Color for kludge line');
  Form.AddBol  ('N', ' Netmail Crash',        50, 12, 67, 12, 15, 3, @bbsCfg.NetCrash, Topic + 'Use netmail crash flag');
  Form.AddBol  ('M', ' Netmail Hold',         51, 13, 67, 13, 14, 3, @bbsCfg.NetHold, Topic + 'Use netmail hold flag');
  Form.AddBol  ('1', ' Netmail Killsent',     47, 14, 67, 14, 18, 3, @bbsCfg.NetKillsent, Topic + 'Use netmail killsent flag');

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_NewUser1Settings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09New User Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' New User Settings 1 ';

  Box.Open (18, 5, 63, 16);

  VerticalLine (39, 7, 14);

  Form.AddBol  ('A', ' Allow New Users',    22,  7, 41,  7, 17, 3, @bbsCfg.AllowNewUsers, Topic);
  Form.AddByte ('S', ' Security',           29,  8, 41,  8, 10, 3, 1, 255, @bbsCfg.NewUserSec, Topic);
  Form.AddPass ('P', ' Password',           29,  9, 41,  9, 10, 15, 15, @bbsCfg.NewUserPW, Topic);
  Form.AddBol  ('N', ' New User Feedback',  20, 10, 41, 10, 19, 3, @bbsCfg.NewUserEmail, Topic);
  Form.AddBol  ('U', ' Use USA Phone',      24, 11, 41, 11, 15, 3, @bbsCfg.UseUSAPhone, Topic);
  Form.AddTog  ('E', ' User Name Format',   21, 12, 41, 12, 18, 8, 0, 3, 'As_Typed Upper Lower Proper', @bbsCfg.UserNameFormat, Topic);
  Form.AddWord ('T', ' Start Msg Group',    22, 13, 41, 13, 17, 5, 0, 65535, @bbsCfg.StartMGroup, Topic);
  Form.AddWord ('R', ' Start File Group',   21, 14, 41, 14, 18, 5, 0, 65535, @bbsCfg.StartFGroup, Topic);

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_NewUser2Settings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
Begin
  Topic := '|03(|09New User Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' New User Settings 2 ';

  Box.Open (8, 5, 73, 21);

  VerticalLine (25, 7, 19);
  VerticalLine (58, 7, 16);

  Form.AddBol  ('A', ' Ask Theme',      14,  7, 27,  7, 11, 3, @bbsCfg.AskTheme, Topic);
  Form.AddBol  ('S', ' Ask Real Name',  10,  8, 27,  8, 15, 3, @bbsCfg.AskRealName, Topic);
  Form.AddBol  ('K', ' Ask Alias',      14,  9, 27,  9, 11, 3, @bbsCfg.AskAlias, Topic);
  Form.AddBol  ('T', ' Ask Street',     13, 10, 27, 10, 12, 3, @bbsCfg.AskStreet, Topic);
  Form.AddBol  ('C', ' Ask City/State',  9, 11, 27, 11, 16, 3, @bbsCfg.AskCityState, Topic);
  Form.AddBol  ('Z', ' Ask ZipCode',    12, 12, 27, 12, 13, 3, @bbsCfg.AskZipCode, Topic);
  Form.AddBol  ('H', ' Ask Home Phone',  9, 13, 27, 13, 16, 3, @bbsCfg.AskHomePhone, Topic);
  Form.AddBol  ('E', ' Ask Cell Phone',  9, 14, 27, 14, 16, 3, @bbsCfg.AskDataPhone, Topic);
  Form.AddBol  ('I', ' Ask Birthdate',  10, 15, 27, 15, 15, 3, @bbsCfg.AskBirthdate, Topic);
  Form.AddBol  ('G', ' Ask Gender',     13, 16, 27, 16, 12, 3, @bbsCfg.AskGender, Topic);
  Form.AddBol  ('M', ' Ask Email',      14, 17, 27, 17, 11, 3, @bbsCfg.AskEmail, Topic);
  Form.AddBol  ('L', ' Ask UserNote',   11, 18, 27, 18, 14, 3, @bbsCfg.AskUserNote, Topic);
  Form.AddBol  ('R', ' Ask Screensize',  9, 19, 27, 19, 16, 3, @bbsCfg.AskScreenSize, Topic);

  Form.AddTog  ('D', ' Date Type',      47,  7, 60,  7, 11, 8, 1, 4, 'MM/DD/YY DD/MM/YY YY/DD/MM Ask', @bbsCfg.UserDateType, Topic);
  Form.AddTog  ('O', ' Hot Keys',       48,  8, 60,  8, 10, 3, 0, 2, 'No Yes Ask', @bbsCfg.UserHotKeys, Topic);
  Form.AddTog  ('P', ' Protocol',       48,  9, 60,  9, 10, 3, 0, 2, 'No Yes Ask', @bbsCfg.UserProtocol, Topic);
  Form.AddTog  ('N', ' Node Chat',      47, 10, 60, 10, 11, 6, 0, 2, 'Normal ANSI Ask', @bbsCfg.UserFullChat, Topic);
  Form.AddTog  ('F', ' File List',      47, 11, 60, 11, 11, 6, 0, 2, 'Normal ANSI Ask', @bbsCfg.UserFileList, Topic);
  Form.AddTog  ('1', ' Message Reader', 42, 12, 60, 12, 16, 6, 0, 2, 'Normal ANSI Ask', @bbsCfg.UserReadType, Topic);
  Form.AddTog  ('2', ' Read at Index',  43, 13, 60, 13, 15, 3, 0, 2, 'No Yes Ask', @bbsCfg.UserReadIndex, Topic);
  Form.AddTog  ('3', ' Email at Index', 42, 14, 60, 14, 16, 3, 0, 2, 'No Yes Ask', @bbsCfg.UserMailIndex, Topic);
  Form.AddTog  ('4', ' Message Editor', 42, 15, 60, 15, 16, 4, 0, 2, 'Line Full Ask', @bbsCfg.UserEditorType, Topic);
  Form.AddTog  ('5', ' Quote Mode',     46, 16, 60, 16, 12, 6, 0, 2, 'Line Window Ask', @bbsCfg.UserQuoteWin, Topic);

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

Procedure Configuration_ConsoleSettings;
Var
  Box   : TAnsiMenuBox;
  Form  : TAnsiMenuForm;
  Topic : String[80];
  Count : Byte;
Begin
  Topic := '|03(|09Console Settings|03) |01-|09> |15';

  Box  := TAnsiMenuBox.Create;
  Form := TAnsiMenuForm.Create;

  Box.Header := ' Console Settings ';

  Box.Open (5, 5, 76, 16);

  VerticalLine (17, 7, 14);
  VerticalLine (64, 7, 10);

  For Count := 1 to 8 Do
    Form.AddStr (strI2S(Count)[1], ' F' + strI2S(Count) + ' Macro', 7, 6 + Count, 19, 6 + Count, 10, 30, 60, @bbsCfg.SysopMacro[Count], Topic);

  Form.AddBol  ('S', ' Status Bar',  52,  7, 66,  7, 12, 3, @bbsCfg.UseStatusBar, Topic);
  Form.AddAttr ('1', ' Color 1',     55,  8, 66,  8,  9, @bbsCfg.StatusColor1, Topic);
  Form.AddAttr ('2', ' Color 2',     55,  9, 66,  9,  9, @bbsCfg.StatusColor2, Topic);
  Form.AddAttr ('3', ' Color 3',     55, 10, 66, 10,  9, @bbsCfg.StatusColor3, Topic);

  Form.Execute;
  Form.Free;

  Box.Close;
  Box.Free;
End;

End.
