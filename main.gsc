#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\menu;
#include scripts\utils;
#include scripts\functions;
#include scripts\functionscall;


init()
{
    setdvar("sv_cheats",1);
    level thread onplayerconnect();
    level.panhelis = [];
}

onplayerconnect()
{
    while(true)
    {
        level waittill("connected",player);
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    while(true)
    {
        self waittill("spawned_player");
        if(self ishost())
        {
            setdvar("cg_hudchatposition","600 250");
            setdvar("cg_chatheight",8);
            self FreezeControls(false);
            IPrintLnBold("Welcome To Safefail");
            self setdvars();
            SetSlowMotion(getdvarfloat("slowmo"), getdvarfloat("slowmo"), 0);
            self functionscall();
            self menuinit();
            self thread MonitorButtons();
            self thread alwaysclasschange();
            self thread kcweaponloop();
            self thread buttonsnotify();
            self thread savepos();
            self thread loadpos();
            self thread ufobind();
        }

        if(!self IsHost())
        {
            if(GetDvar("saveplayerposmap" + self GetEntityNumber()) == getdvar("mapname"))
            self SetOrigin(getdvarvector("saveplayerpos" + self GetEntityNumber()));
        }

        while(!self IsHost())
        {
            self FreezeControls(true);
            waitframe();
        }
    }
}

ufobind()
{
    while(true)
    {
        self waittill("+melee");
        if(getdvar("ufobind") == "[ON]" && self GetStance() == "crouch")
        {
            executecommand("ufo");
            self waittill("+melee");
            executecommand("ufo");
        }
    }
}

savepos()
{
    while(true)
    {
        self waittill("+actionslot 3");
        if(self GetStance() == "crouch" && !self isinmenu())
        {
            setdvar("savepos",self GetOrigin());
            setdvar("saveposmap",getdvar("mapname"));
            setdvar("saveangles",self getangles());
            IPrintLnBold("Position Saved " + self GetOrigin());
        }
    }
}

loadpos()
{
    while(true)
    {
        self waittill("+actionslot 2");
        if(self GetStance() == "crouch" && !self isinmenu() && getdvar("saveposmap") == getdvar("mapname"))
        {
            self SetOrigin(getdvarvector("savepos"));
            self setangles((0,getdvarvector("saveangles")[1],getdvar("stztilt") == "[ON]" ? 180 : 0));
        }
    }
}






setdvars()
{
    SetDvarIfUni("killcamweapon","[OFF]");
    SetDvarIfUni("infiniteability","[OFF]");
    SetDvarIfUni("godmode","[OFF]");
    SetDvarIfUni("alwayscanswap","[OFF]");
    SetDvarIfUni("instashoot","[OFF]");
    SetDvarIfUni("stztilt","[OFF]");
    SetDvarIfUni("midairprone","[OFF]");
    SetDvarIfUni("slams","[ON]");
    SetDvarIfUni("infeq","[OFF]");
    SetDvarIfUni("slowmo",1);
    SetDvarIfUni("aimbot","[OFF]");
    SetDvarIfUni("aimbotrange",100);
    SetDvarIfUni("aimbotweaponname","[undefined]");
    SetDvarIfUni("hitaimbot","[OFF]");
    SetDvarIfUni("hitaimbotweaponname","[undefined]");
    SetDvarIfUni("ufobind","[ON]");
    SetDvarIfUni("firstnac","[undefined]");
    SetDvarIfUni("secondnac","[undefined]");
    self setupbind("nacmod","[OFF]",::nacmodbind);
    SetDvarIfUni("firstinstaswap","[undefined]");
    SetDvarIfUni("secondinstaswap","[undefined]");
    self setupbind("instaswap","[OFF]",::instaswapbind);
    self setupbind("canswap","[OFF]",::canswapbind);
    self setupbind("illusioncanswap","[OFF]",::illusioncanswapbind);
    self setupbind("illusion","[OFF]",::illusionbind);
    self setupbind("houdini","[OFF]",::houdinibind);
    self setupbind("stztiltbind","[OFF]",::stztiltbind);
    self setupbind("vish","[OFF]",::vishbind);
    self setupbind("gunlock","[OFF]",::gunlockbind);
    self setupbind("flash","[OFF]",::flashbind);
    self setupbind("hitmarker","[OFF]",::hitmarkerbind);
    self setupbind("damage","[OFF]",::damagebind);
    self setupbind("emp","[OFF]",::empbind);
    self setupbind("pred","[OFF]",::predbind);
    self setupbind("fadetoblack","[OFF]",::fadetoblackbind);
    SetDvarIfUni("realscavenger","[OFF]");
    self setupbind("scavenger","[OFF]",::scavengerbind);
    SetDvarIfUni("ccblimit",2);
    self setupbind("ccb","[OFF]",::ccbbind);
    SetDvarIfUni("ccbcanswaps","[OFF]");
    SetDvarIfUni("eqweapon","airdrop_marker_mp");
    SetDvarIfUni("eqdoswap","[OFF]");
    self setupbind("equipment","[OFF]",::equipmentbind);
    self setupbind("bolt","[OFF]",::boltbind);
    SetDvarIfUni("boltposcount",0);
    SetDvarIfUni("boltspeed",0.25);
    self setupbind("playmovement","[OFF]",::playmovementbind);
    SetDvarIfUni("recordedpoints",0);
    self setupbind("mala","[OFF]",::malabind);
    self setupbind("smooth","[OFF]",::smoothbind);
    self setupbind("melee","[OFF]",::meleebind);
    self setupbind("lunge","[OFF]",::lungebind);
    self setupbind("reload","[OFF]",::reloadbind);
    self setupbind("emptyreload","[OFF]",::emptyreloadbind);
    self setupbind("sprintin","[OFF]",::sprintinbind);
    self setupbind("sprintloop","[OFF]",::sprintloopbind);
    self setupbind("mantle","[OFF]",::mantlebind);
    self setupbind("slidein","[OFF]",::slideinbind);
    self setupbind("slidestall","[OFF]",::slidestallbind);
    self setupbind("fastreload","[OFF]",::fastreloadbind);
    self setupbind("glide","[OFF]",::glidebind);
    self setupbind("predvision","[OFF]",::predvisionbind);
    self setupbind("reconvision","[OFF]",::reconvisionbind);
    self setupbind("vucanvision","[OFF]",::vucanvisionbind);
    self setupbind("nacnext","[OFF]",::nacnextbind);
    self setupbind("instaswapnext","[OFF]",::instaswapnextbind);
}




//melee 10
//lunge 12
//reload 20
//emptyreload 21
//fastreload 24
//sprintin 32
//glide?? 34
//sprintloop 35
//mantle 51
//slidein 70
//slidestall 71

kcweaponloop()
{
    for(;;)
    {
        if(getdvar("killcamweapon") == "[OFF]")
        {
            self setclientomnvar("ui_killcam_killedby_killstreak",-1);
            self setclientomnvar("ui_killcam_killedby_weapon",-1);
            self setclientomnvar("ui_killcam_killedby_attachment1",-1);
            self setclientomnvar("ui_killcam_killedby_attachment2",-1);
            self setclientomnvar("ui_killcam_killedby_attachment3",-1);
        }
        waitframe();
    }
}


alwaysclasschange()
{  
    game["strings"]["change_class"] = "";
    for(;;)
    {
        self waittill("luinotifyserver",var_00,var_01);
		if(var_00 == "class_select" && var_01 < 60)
		{
			self.class = "custom" + (var_01 + 1);
            maps\mp\gametypes\_class::setclass(self.class);
            self.tag_stowed_back = undefined;
            self.tag_stowed_hip = undefined;
            maps\mp\gametypes\_class::giveandapplyloadout(self.teamname,self.class);
		}
    }
}