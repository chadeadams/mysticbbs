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
IMMEDIATE PRIORITIES (IN ORDER) FOR 1.10 AS OF Sept 22, 2013

1. Netmail/echomail pass-through and HUB stuff
1. FTP FTN server
2. AreaFix
3. TIC processing
4. FileFix
5. Netmail attachments/File hatching
6. Gating

=====================================

This file showcases the direction of where this software wants to go as it
continues to expand.  Some things that will probably be mentioned will be
vague, and serve mostly to remind me of my own ideas.

The scope of this file is to document bugs, future enhancements/ideas and
design elements/issues.

BUGS AND POSSIBLE ISSUES
========================
! FIDONET.NA import when tab separated causes problems
! Zombie processes on MIS linux wait() needs to be called to acknowledge that
  a child is dead?  try it...

- fidonet NA export
- shift+c key in OSX does not work without shiftlock (rudi)?
- need to add QWK network ID to all message bases (remove QWK net flag?)
- need to add QWK networking editor (type: hub, or node)
- need to add QWK network link back to networks defined in editor for each
  message base.  Also need to add both to global editor?
- need to also have the ability to link a specific user account to a QWK
  network from the editor.
- need function to exchange qwk with uplink (passive, login, pw, host, port)
  packet type (qwke/qwk)

! Gender character is asking for ASCII number.  Make new functions for areas
  where we don't want that.

!!!! MPLC should NOT stop compiling EVERYTHING if it finds a single file
     error.

!!!! Subject: NetRunner change to NetRunner vXXX --- FIX IT NOW BAD BAD BAD

! check forced messages in new fs editor might not be enforced.
! Weird console slowdown with test.txt in Win7 use MVIEW to test
! GE option 32 (change def protocol) might be broken
! Node chat goes haywire at 1000 lines scrollback
! Node chat needs to actualy word wrap not nickname wrap.
! Node chat does not seem to account for prompt MCI codes when calculating
  the wrap length.
! Make sure ALL msgbase and filebase MPL variables are in place.
! GOTO does not always work properly in MPL (IceDevil)
! Complex boolean evaluations using numerical variables can sometime fail to
  compile (IceDevil)
! After data file review, add missing variables to various MPL Get/Put
  functions.
! Test midnight rollovers for time (flag for user to be immune to timecheck)
! Fix REAL2STR per Gryphon

FUTURE / IDEAS / WORK IN PROGRESS / NOTES
=========================================
- Need to add MCI code for Default Protocol
        - Make function get protocol by Key
- Make point mail bundles based off of their uplink (your address)?
- MIS escape confirmation
- Prompts for CONFIG editors
- matrix disconnect if they use the XL command too many times
- index00.html or whatever in FTP server
- buffer echomail export and use mailer LR pointers
- add mystic's downlinks to areas.bbs export?
- add exportto into mutil.ini for [ImportMessageBase] ??
- auto create qwk network message bases?
- qwk net msg dupe detection?
- make -CFG mode NOT use inactivity timeout
- ability when editing a posted message to be able to toggle the Private flag
  if the base is Pub/Priv
- when editing an already posted message with reference linkage, export the
  quote data from the original message...
- in file listing jump to files by typing the file number
- add QWKNet base type or no?  leaning towards no because it might limit
  hybrid FIDO/QWK networks which maybe we can do currently?  need to think
  about the SENT flag and how we could determine which type it was circulated
  to.  most likely would have to do external pointers for each tosser and
  just set the SENT flag when its first encountered
- make tiosocket buffer size dynamic.  increase data sockets in ftp to 32kb
- all display files to search for .hlp before ANS?
- fix END in lightbar file lists so it doesn't suck.
- externalize qwk and file list compiler class.  qwk for mystic/mis filelist
  for mystic/mutil.  add compiler templates, file include, and new vs all
  generation for all.
- make embedded ANSI in file_id display correctly.
- abstract ansi browser to be used for ansi archive viewer and sysop file
  manager (as well as the ANSI gallery).
- msg readers uses msgbase_ansi like mystic 2
- when mutil is tossing a packet and auto creates an area figure out if there
  can be a way to automatically create the uplink back to the originating
  node.
- expand max filename size for 70 to 255 chars? do below first...
- make file list use buffered IO class for reading .dir files (8k)
- global user editor for user flags, def protocol, etc etc
- ability to configure auto signatures (2 of them) one for handle and one
  for real name bases
- ability to download ANSIs while actually viewing them in the gallery
- optional Menu scroller during input?
- Menu type: Lightbar/Form  OR  just change standard lightbar to work that
  way which i think is the best approach actually but will it break existing
  lightbars (shouldnt?)
- ESC moves back in ANSI gallery only exits if dir = root?
- Color, boxtype, and input configuration for configuration
- global file editor like msg base
- redo voting booth externalize user storage and allow unlimited questions
  plus maybe categories.  or at least up it to like 50 questions or
  something and also add in the "created" date to the voting question itself
- Fix up new FS editor to use passed template and editor contraints.
     - Test with file description editor.
- Strip pipe colors/ANSI from message option?
- allow ANSI option for msg bases?
- revamp file directory listing editor to use new ansi classes
- AREAS.BBS import?
- PGUP/DOWN moves bases in message base editor?
- AreaFix
- Echomail export saves last scanned pointers
- FileFix / TIC
! Use NetReply in RecMB also Reply to another base?
- EXCLUDE from all files list. important.
- Reply to echomail via netmail (this is allowed already using ext reply acs).
- Amiga .readme and .TIC processing (similar)
-  ^^ or utility to find .readme in the smae dir and add to file_id.diz if
   it does not exist.
- New files list to MUTIL based X number of days
- All/new file list template files like TOP XX
- MUTIL create FILES.BBS in the file base directory
- MUTILs new DIR import of msg bases could have optional config to reference
  a series of .NA files to get the name/description of bases.
- QWK via email?
- Blind upload for single file upload (also message upload)
- Email validation
- Recode FCHECK into MUTIL, but also add the option to phsyically delete the
  file record instead of marking it offline.
- multiple add export in globa msg base editor
- Need ALL mystic servers to hvae the option to auto-ban an IP address if it
  connects X amount of times in X seconds.
- Outbound telnet feature
- Add "PREVIEW" option to message editors
- Finish Threaded message reader
- Gallows Pole MPL
- Add "high roller/smack talk" into BlackJack
- BBS email autoforwarded to Internet email
- Ability to send internet email to people from within the BBS.
- ANSI post-processor for message uploads via FSE
- ANSI reading support in fullscreen reader
- Ability to override read-type per message base (usersetting/normal/lightbar)
- Ability to override index setting per message base (same as above)
- Ability to override listing type per file base (same as above)
- Ability to list files in a base that is not the current file base
- MCI code to show how many files are in current filebase
- Online text editor / ansi editor?
- Externalize remaining prompt data (msg flags, etc)
- File comments and rating system
- Integrate eventual online ANSI help system into configuration utilities
- Split 1 and 2 column msg/file list prompts and provide a user ability to
  pick which they'd like to use?
- File attachments and crossposts
- User-directories?  How could this be used?  Next two items?
- Ability to save a message post if a user is disconnected while posting.
- Ability to save file queue if a user is disconnected with a queue.
- User 2 User split screen chat
- NodeSpy split chat
- MBBSCGI (or PHP DLL) [Grymmjack might have the only MBBSCGI copy]
- If not the above then finish the HTTP server?
- SDL versions of m_input and m_output?
- Possibility of OS/2 port again?  Need to find a working OS/2 VMware in
  order to do this.
- MVIEW rewrite to mimic oldskool AcidView type deals, which would be amazing
  combined with the SDL stuff if that happens.
- Mystic-DOS rewrite or just code a file manager which would probably be a
  lot nicer using the new ANSI UI.
- MIDE version using the Lazaurs GUI editor [Spec].   Maybe he would be
  interested in working on that?
- Filebase allow anonymous flag for FTP or just use FreeFiles
- Template system similar to Mystic 2 (ansiedit.ans ansiedit.ans.cfg)
- Rename Template filenames to allow more than 8 characters (for clarity)
- ANSI message upload post processor option: Auto/Disabled/Ask
- Finish optional user prompts
- MCI code for FS ansi viewer?
- Redo random ANSI system to use A-Z instead of 1-9 can have upgrade util
  rename them automatically.
- LastOn revamp make sure its not global and new stuff is populated
- MPL fAppend?  Why didnt I add that?
- MCI code to save and restore user screen?
- BBS email forward to e-mail address
- Email pasword resets
- Email verification
- MPL trunc/round?
- Salted MD5, SHA-1 or SHA-256 password encryption?
- User editor: Reset password/Force change... cannot view PWs

RANDOM DRUNKEN BRAINDUMP AKA DESIGN DETAILS
===========================================

-------------------------------------------------------------------------
Disconnect while posting design:

1. Before msg post or msg reply Session.Msgs.Posting is set to that bases
   Index.
2. All editors reset this value on any save/abort
3. Any disconnect checks that value.
4. If disconnect while value is set:
     a. Save MSGTMP from node's TEMP dir into DATA as msg_<UID>.tmp
          overwrite if exists
     b. Save MsgText into DATA as msg_<UID>.txt with format:
          Line 1: Base perm index
          Line 2: Msg From
          Line 3: Msg To
          Line 4: Msg Subj
          Line 5: Network address (or blank if none)
          Line 6: MsgText
             overwrite if exists
          NOTE WHAT ABOUT QUOTE TEXT - HAS TO BE SAVED TOO.
5. During LOGIN, check for msg_<UID>.txt or have menu command to do it?
6. If exists, process and prompt user:

     You were recently disconnected while posting a message:

       Base: Clever Message Base Name
         To: MOM JOKEZ R FUNNY LOLZ
       Subj: I eat hot coal.

     (R)esume post, (D)elete, or (A)sk me later?

7. Case result:
     Resume:
        Copy msg_UID.tmp if exists to MSGTMP in temp node directory
        Populate MsgText and execute editor with the other values
        Execute editor
        If save... save... this will be the hard part. :(
        If abort... delete msg_UID* since they aborted?
        What happens if they disconnect while continuing?  lol
           make sure this is handled appropriately.
     Delete:
        Delete msg_UID* in data.
     Ask later:
        Do nothing.  Keep files so Mystic asks on next login.
        Or also Mystic could ask any time a MP menu command happens
        But all of this stuff should be optional?

PROBLEM: When we localize MsgText for the ANSI viewer integration...
how will this work?  I am not sure it really can work without it being
global.  We cannot save what we do not have access to from a class.

SOLUTION: Actual MsgText should be separate from Attributes in the msg
base ANSI class.  Memory requirements almost double though for MsgText
storage if it remains global = 1000 lines x 80. 80,000 bytes memory per
node.  But attributes are only really required while READING.  So maybe
somehow it can be separated so attributes are specific to reading and
the entire class is "unused" until then?

-----------------------------------------------------------------------

CHANGE to support up to 132x50 line mode (requires lots of console
mode library updates and screensave/restore changes)

1. terminal "screen length" is no longer an option of lines but a
   selection:

     80x24
     80x49
     132x49

2. all display files and templates will have this logic added:

      if 132 mode .132.ans is the extention
      if  50 mode .50.ans is the extention
      if  25 mode then .ans is the extention

-----------------------------------------------------------------------

NEW TEMPLATE system

templates will be .cfg files with various things defined within them
based on the template.  no more "injecting" screeninfo codes (|!X) into
files.  Extentions for random ANSI templates:

ansiflst.ans = ansiflist.ans.cfg
ansiflst.an1 = ansiflist.an1.cfg

50 line mode template examples with random selected templates

ansiflst.50.ans = ansiflist.50.ans.cfg
ansiflst.50.an1 = ansiflist.50.an1.cfg

-----------------------------------------------------------------------

FILE rating / comments system

1. what type? 4 or 5 stars, or 1-10, or 0-100 rating system?
2. records already updated to allow for either

-----------------------------------------------------------------------

TANSILINEBUFFER:

LoadToBuffer (Ansi file)
SaveToFile   (Ansi file)
SaveToBuffer (Linelength)

WrapLine    (XPOS)
InsertLine
DeleteLine
JoinLines
InsertChar  (XPOS, Ch, Attr)
ReplaceChar (XPOS, Ch, Attr
ReplaceLine


1.11
====
- MUTIL option to create bases to (msgbase path + domainname) directory.
- MUTIL option to scan recursively when creatign bases by data files
- Rewrite user login functions and MATRIX
- Change temp directories.  Add MIS/MUTIL/FTN/NODE
- User directories (research disk performance with a zillion dirs)
      1. Ability to save file batch queues between sessions
      2. Ability to save "draft" message posts between sessions
      3. Accessible via /home in FTP (virtual dir) allows QWK/REP
- New FS editor with DRAW MODE w/ inline ANSI/pipe editing
- Option to send QWK packet by e-mail OR download it
- Option to "upload" REP packet by sending email to BBS (qwk@yourbbs.com)?
     - Needs additional research
! POSSIBLE removal of local console in Windows and STDIO usage in Linux
     ^ Massive performance increase possible here as well as:
! MIS event system (possible 1.10)
! Password reset via email (possible 1.10)
! Email verification system (for access upgrades) (possible 1.10)
- New message reader functions allows inline ANSI
- Msg editor can "post process" ANSIs to be 79 columns max in stored line
  length (bbs friendly)
- Rewrite of MBBSWEB or integrated HTML server?  still need a good designer
  that actually will put a lot of time into it
- Rewrite of ANSI template system (.ini files or mystic2 format?)

=================================================

CODE RESTRUCTURE naming (possibly remove mystic_ prefix):

mystic
mystic_records
mystic_common (called db now)
mystic_server_binkp
mystic_server_telnet
mystic_server_ftp
mystic_server_pop3
mystic_server
mystic_client
mystic_client_smtp
mystic_client_ftp
mystic_server_events
mystic_cmd_server
mystic_cmd_fidopoll
mystic_cmd_terminal
mystic_class_binkp
mystic_class_qwk
mystic_class_menudata
mystic_class_msgbase
mystic_class_msgbase_jam
mystic_class_msgbase_squish
mystic_class_arcview
mystic_class_arcview_zip
mystic_class_arcview_rar
mystic_class_nodelist
mystic_class_logging (on-the-fly log rolling, trimming, etc)
mystic_config_filearea
mystic_ansi_intro
mystic_ansi_monitor
mystic_ansi_terminal
mystic_bbs_core
mystic_bbs_msgbase
mystic_bbs_filebase
mystic_bbs_general
mystic_bbs_doors
mystic_bbs_user
mystic_bbs_nodechat
mystic_bbs_userchat
mystic_bbs_sysopchat
mystic_bbs_ansibox
mystic_bbs_ansimenu
mystic_bbs_ansihelp
mystic_bbs_ansiinput
mystic_bbs_ansidir
mystic_bbs_lineedit
mystic_bbs_fulledit
mystic_bbs_menus
mystic_bbs_io
mystic_bbs_mplexecute
mystic_bbs_mpltypes
mystic_bbs_mplcommon
mystic_bbs_mplcompile

=============================

DRAW MODE /D

ansieditor_draw
ansieditor
ansieditor_help
ansieditor_color
ansieditor_glyph
