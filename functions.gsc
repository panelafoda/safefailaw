#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\utils;
#include scripts\menu;
#include scripts\main;



togglegodmode()
{
    if(getdvar("godmode") == "[OFF]")
    {
        setdvar("godmode","[ON]");
        executecommand("god");
    }
    else
    {
        setdvar("godmode","[OFF]");
        executecommand("god");
    }
}


togglealwayscanswap()
{
    if(getdvar("alwayscanswap") == "[OFF]")
    {
        setdvar("alwayscanswap","[ALL]");
        self thread alwayscanswapallloop();
    }
    else if(getdvar("alwayscanswap") == "[ALL]")
    {
        self notify("stopallcanswap");
        setdvar("alwayscanswap","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
        setdvar("alwayscanswapweapon",self GetCurrentWeapon());
        self thread alwayscanswapspecificloop();
    }
    else
    {
        self notify("stopspecificcanswap");
        setdvar("alwayscanswap","[OFF]");
    }
}

alwayscanswapallloop()
{
    self endon("stopallcanswap");
    x = self GetCurrentWeapon();
    foreach(weapon in self GetWeaponsListPrimaries())
    if(weapon != x)
    {
        self takeweapongood(weapon);
        self giveweapongood(weapon);
    }

    while(true)
    {
        self waittill("weapon_change");
        x = self GetCurrentWeapon();
        foreach(weapon in self GetWeaponsListPrimaries())
        if(weapon != x)
        {
            self takeweapongood(weapon);
            self giveweapongood(weapon);
        }
    }
}

alwayscanswapspecificloop()
{
    self endon("stopspecificcanswap");
    while(true)
    {
        self waittill("weapon_change");
        x = self GetCurrentWeapon();
        if(x != getdvar("alwayscanswapweapon") && self HasWeapon(getdvar("alwayscanswapweapon")) && !IsSubStr(x,"alt"))
        {
            self takeweapongood(getdvar("alwayscanswapweapon"));
            self giveweapongood(getdvar("alwayscanswapweapon"));
        }
    }
}



toggleinstashoot()
{
    if(getdvar("instashoot") == "[OFF]")
    {
        setdvar("instashoot","[ALL]");
        self thread allinstashoot();
    }
    else if(getdvar("instashoot") == "[ALL]")
    {
        self notify("stopallinstashoot");
        setdvar("instashoot","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
        setdvar("instashootweapon",self GetCurrentWeapon());
        self thread specificinstashoot();
    }
    else
    {
        self notify("stopspecificinstashoot");
        setdvar("instashoot","[OFF]");
    }
}

allinstashoot()
{
    self endon("stopallinstashoot");
    while(true)
    {
        self waittill("weapon_change");
        if(self GetCurrentWeapon() != "none")
        self SetSpawnWeapon(self GetCurrentWeapon());
    }
}

specificinstashoot()
{
    self endon("stopspecificinstashoot");
    while(true)
    {
        self waittill("weapon_change");
        if(self GetCurrentWeapon() == getdvar("instashootweapon"))
        self SetSpawnWeapon(self GetCurrentWeapon());
    }
}


togglestztilt()
{
    if(getdvar("stztilt") == "[OFF]")
    setdvar("stztilt","[ON]");
    else 
    setdvar("stztilt","[OFF]");

    self setangles((self.angles[0],self.angles[1],getdvar("stztilt") == "[ON]" ? 180 : 0));
}

nacto(weapon)
{
    x = self GetCurrentWeapon();
    self takeweapongood(x);
    self giveweapon(weapon);
    self SwitchToWeapon(weapon);
    waitframe();
    waitframe();
    self giveweapongood(x);
}



togglemidairprone()
{
    if(getdvar("midairprone") == "[OFF]")
    {
        setdvar("midairprone","[ON]");
        self thread midairproneloop();
    }
    else
    {
        setdvar("midairprone","[OFF]");
        self notify("stopmidairprone");
    }
}

midairproneloop()
{
    self endon("stopmidairprone");
    while(true)
    {
        if(self GetStance() == "crouch" && !self IsOnGround())
        {
            self SetStance("prone");
            while(self GetStance() != "stand")
            waitframe();
        }
        waitframe();
    }
}


toggleslams()
{
    if(getdvar("slams") == "[ON]")
    setdvar("slams","[OFF]");
    else
    setdvar("slams","[ON]");

    self playerallowhighjumpdrop(getdvar("slams") == "[ON]" ? 1 : 0);
}


toggleinfeq()
{
    if(getdvar("infeq") == "[OFF]")
    {
        setdvar("infeq","[ON]");
        self thread infeqloop();
    }
    else
    {
        setdvar("infeq","[OFF]");
        self notify("stopinfeq");
    }
}

infeqloop()
{
    self endon("stopinfeq");
    self GiveMaxAmmo(self GetCurrentOffHand());
    while(true)
    {
        self waittill("grenade_fire");
        self GiveMaxAmmo(self GetCurrentOffHand());
    }
}


playertoch(player)
{
    player SetOrigin(self getcrosshaircenter());
    player SetOrigin(self getcrosshaircenter());
    setdvar("saveplayerpos" + player GetEntityNumber(),player GetOrigin());
    setdvar("saveplayerposmap" + player GetEntityNumber(),getdvar("mapname"));
}

kickdumbass(player)
{
    Kick(player GetEntityNumber());
}



spawndumbass()
{
    executecommand("spawnbot");
}

alltoch()
{
    foreach(player in level.players)
    if(player != self)
    {
        player SetOrigin(self getcrosshaircenter());
        setdvar("saveplayerpos" + player GetEntityNumber(),player GetOrigin());
        setdvar("saveplayerposmap" + player GetEntityNumber(),getdvar("mapname"));
    }
}

botslookatme()
{
    foreach(player in level.players)
    if(player != self)
	player setangles(VectorToAngles(((self.origin)) - (player getTagOrigin("j_head"))));
}

kickdumbasses()
{
    foreach(player in level.players)
    if(player != self)
    Kick(player GetEntityNumber());
}


changegravity()
{
    grav = getdvarint("g_gravity");
    grav -= 50;
    if(grav < 350)
    grav = 800;
    setdvar("g_gravity",grav);
}

changegspeed()
{
    speed = getdvarint("g_speed");
    speed += 20;
    if(speed == 210)
    speed = 200;
    if(speed > 500)
    speed = 190;
    setdvar("g_speed",speed);
}

changeslowmo()
{
    if(getdvarfloat("slowmo") == 1)
    setdvar("slowmo",0.5);
    else if(getdvarfloat("slowmo") == 0.5)
    setdvar("slowmo",0.25);
    else if(getdvarfloat("slowmo") == 0.25)
    setdvar("slowmo",1);

    SetSlowMotion(getdvarfloat("slowmo"), getdvarfloat("slowmo"), 0);
}



toggleinfiniteability()
{
    if(getdvar("infiniteability") == "[OFF]")
    {
        setdvar("infiniteability","[ON]");
        self thread infiniteabilityloop();
    }
    else
    {
        setdvar("infiniteability","[OFF]");
        self notify("stopinfiniteability");
    }
}

infiniteabilityloop()
{
    self endon("stopinfiniteability");
    while(true)
    {
        self batteryfullrecharge(self getcurrentoffhand());
        waitframe();
    }
}


togglekillcamweapon()
{
    if(getdvar("killcamweapon") == "[OFF]")
    setdvar("killcamweapon","[ON]");
    else
    setdvar("killcamweapon","[OFF]");
}



givevish()
{
    x = self GetCurrentWeapon();
    if(getdvar("instashoot") == "[ALL]")
    {
        self notify("stopallinstashoot");
        self SetSpawnWeapon("none");
        wait 0.2;
        self thread allinstashoot();
    }
    else if(getdvar("instashoot") != "[OFF]")
    {
        if(x == getdvar("instashootweapon"))
        {
            self notify("stopspecificinstashoot");
            self SetSpawnWeapon("none");
            wait 0.2;
            self thread specificinstashoot();
        }
    }
    else
    {
        self SetSpawnWeapon("none");
    }
}


spawndaheli()
{
    if(level.players.size > 1)
    {
        foreach(player in level.players)
        if(player != self)
        {
            level.panhelis[level.panhelis.size] = spawnhelicopter(player,self.origin + (0,0,2000),self.angles,level.warbirdsetting["Warbird"].vehicle,level.warbirdsetting["Warbird"].modelbase);
            break;
        }
    }
    else
    IPrintLnBold("Spawn A Bot First");
}


deletechoppa()
{
    foreach(heli in level.panhelis)
    heli delete();
}



toggleaimbot()
{
    if(getdvar("aimbot") == "[OFF]")
    {
        setdvar("aimbot","[NORMAL]");
        self thread normalaimbotloop();
    }
    else if(getdvar("aimbot") == "[NORMAL]")
    {
        self notify("stopnormalaimbot");
        setdvar("aimbot","[UNFAIR]");
        self thread unfairaimbotloop();
    }
    else if(getdvar("aimbot") == "[UNFAIR]")
    {
        self notify("stopunfairaimbot");
        setdvar("aimbot","[OFF]");
    }
}

normalaimbotloop()
{
    self endon("stopnormalaimbot");
    while(true)
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(self GetCurrentWeapon() == getdvar("aimbotweapon") && player != self && Distance(self getcrosshaircenter(), player.origin) < getdvarint("aimbotrange"))
        player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
    }
}

unfairaimbotloop()
{
    self endon("stopunfairaimbot");
    while(true)
    {
        self waittill("weapon_fired");
        foreach(player in level.players)
        if(self GetCurrentWeapon() == getdvar("aimbotweapon") && player != self)
        player [[level.callbackPlayerDamage]]( self, self, 99999, 8, "MOD_RIFLE_BULLET", self getcurrentweapon(), player.origin, (0,0,0), "neck", 0 );
    }
}

changeaimbotrange()
{
    if(getdvarint("aimbotrange") == 100)
    setdvar("aimbotrange",200);
    else if(getdvarint("aimbotrange") == 200)
    setdvar("aimbotrange",300);
    else if(getdvarint("aimbotrange") == 300)
    setdvar("aimbotrange",400);
    else if(getdvarint("aimbotrange") == 400)
    setdvar("aimbotrange",500);
    else if(getdvarint("aimbotrange") == 500)
    setdvar("aimbotrange",1000);
    else if(getdvarint("aimbotrange") == 1000)
    setdvar("aimbotrange",1500);
    else if(getdvarint("aimbotrange") == 1500)
    setdvar("aimbotrange",2000);
    else if(getdvarint("aimbotrange") == 2000)
    setdvar("aimbotrange",100);
}


selectaimbotweapon()
{
    setdvar("aimbotweapon",self GetCurrentWeapon());
    setdvar("aimbotweaponname","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
}




togglehitaimbot()
{
    if(getdvar("hitaimbot") == "[OFF]")
    {
        setdvar("hitaimbot","[ON]");
        self thread hitaimbotloop();
    }
    else
    {
        self notify("stophitaimbot");
        setdvar("hitaimbot","[OFF]");
    }
}

hitaimbotloop()
{
    self endon("stophitaimbot");
    while(true)
    {
        self waittill("weapon_fired");
        if(self GetCurrentWeapon() == getdvar("hitaimbotweapon"))
        self setclientomnvar("damage_feedback","standard");
    }
}

selecthitaimbotweapon()
{
    setdvar("hitaimbotweapon",self GetCurrentWeapon());
    setdvar("hitaimbotweaponname","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
}

givedastreaks()
{
    foreach(var_01 in self.killstreaks)
	{
		maps\mp\killstreaks\_killstreaks::earnkillstreak(var_01,0);
	}
}

giveastreak(streak)
{
    var_02 = maps\mp\killstreaks\_killstreaks::getkillstreakmodules(self,streak);
	self thread maps\mp\killstreaks\_killstreaks::givekillstreak(streak,0,0,self,var_02);
}


toggleufobind()
{
    if(getdvar("ufobind") == "[ON]")
    setdvar("ufobind","[OFF]");
    else
    setdvar("ufobind","[ON]");
}



refilldaammo()
{
    foreach(weapon in self GetWeaponsListPrimaries())
    self GiveMaxAmmo(weapon);
}

takecurrent()
{
    self TakeWeapon(self GetCurrentWeapon());
}

dropcurrent()
{
    self DropItem(self getcurrentweapon());
}

setattachment(attachment)
{
    current = self GetCurrentWeapon();
    if(IsSubStr(current, "camo"))
    {
        namearray = StrTok(current, "_");
        basename = getweaponbasename(current);
        for(i=3;i<namearray.size -1;i++)
        {
            basename = basename + "_" + namearray[i];
        }
        newgun = basename + "_" + attachment + "_" + namearray[namearray.size -1];
    }
    else
    {
        namearray = StrTok(current, "_");
        basename = getweaponbasename(current);
        for(i=3;i<namearray.size;i++)
        {
            basename = basename + "_" + namearray[i];
        }
        newgun = basename + "_" + attachment;
    }

    self TakeWeapon(current);
    self giveweapon(newgun);
    self SetSpawnWeapon(newgun);
}


givedaweapon(weapon)
{
    current = self GetCurrentWeapon();
    if(IsSubStr(current,"camo"))
    {
        namearray = StrTok(current, "_");
        goodgun = weapon + "_" + namearray[namearray.size - 1];
        self GiveWeapon(goodgun);
        self SetWeaponAmmoClip(goodgun, 99999);
        self SetWeaponAmmoStock(goodgun, 99999);
        self SwitchToWeapon(goodgun);
    }
    else
    {
        self giveweapon(weapon);
        self SetWeaponAmmoClip(weapon, 99999);
        self SetWeaponAmmoStock(weapon, 99999);
        self SwitchToWeapon(weapon);
    }
}

givespecial(weapon)
{
    self GiveWeapon(weapon);
    self SwitchToWeapon(weapon);
}


giveakimbop()
{
    akimboprimary();
}

giveakimbos()
{
    akimbosecondary();
}



selectfirstnac()
{
    setdvar("firstnac","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
    setdvar("firstnacweapon",self GetCurrentWeapon());
}

selectsecondnac()
{
    setdvar("secondnac","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
    setdvar("secondnacweapon",self GetCurrentWeapon());
}


nacmodbind(bind)
{
    self endon("stopnacmod");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            if(self GetCurrentWeapon() == getdvar("firstnacweapon"))
            self nacto(getdvar("secondnacweapon"));
            else if(self GetCurrentWeapon() == getdvar("secondnacweapon"))
            self nacto(getdvar("firstnacweapon"));
        }
    }
}



instaswapto(weapon)
{
    x = self GetCurrentWeapon();
    self takeweapongood(x);
    self giveweapon(weapon);
    self SetSpawnWeapon(weapon);
    waitframe();
    waitframe();
    self giveweapongood(x);
}



selectfirstinstaswap()
{
    setdvar("firstinstaswap","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
    setdvar("firstinstaswapweapon",self GetCurrentWeapon());
}

selectsecondinstaswap()
{
    setdvar("secondinstaswap","[" + getweapondisplayname(self GetCurrentWeapon()) + "]");
    setdvar("secondinstaswapweapon",self GetCurrentWeapon());
}


instaswapbind(bind)
{
    self endon("stopinstaswap");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            if(self GetCurrentWeapon() == getdvar("firstinstaswapweapon"))
            self instaswapto(getdvar("secondinstaswapweapon"));
            else if(self GetCurrentWeapon() == getdvar("secondinstaswapweapon"))
            self instaswapto(getdvar("firstinstaswapweapon"));
        }
    }
}


canswap()
{
    x = self GetCurrentWeapon();
    self takeweapongood(x);
    self giveweapongood(x);
    self SwitchToWeapon(x);
}


canswapbind(bind)
{
    self endon("stopcanswap");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self canswap();
    }
}

illusioncanswapbind(bind)
{
    self endon("stopillusioncanswap");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self canswap();
            waitframe();
            self SetSpawnWeapon(self GetCurrentWeapon());
        }
    }
}

illusionbind(bind)
{
    self endon("stopillusion");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self SetSpawnWeapon(self GetCurrentWeapon());
    }
}

houdinibind(bind)
{
    self endon("stophoudini");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self DisableWeapons();
            waitframe();
            self EnableWeapons();
            self SetSpawnWeapon(self GetCurrentWeapon());
        }
    }
}

stztiltbind(bind)
{
    self endon("stopstztiltbind");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self togglestztilt();
    }
}



vishbind(bind)
{
    self endon("stopvish");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self givevish();
    }
}


gunlockbind(bind)
{
    self endon("stopgunlock");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self SwitchToWeaponImmediate("alt_" + self GetCurrentWeapon());
            waitframe();
            self canswap();
        }
    }
}

//self maps\mp\_flashgrenades::applyflash(1,1,0);


flashbind(bind)
{
    self endon("stopflash");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self maps\mp\_flashgrenades::applyflash(1.5,1.5,0);
    }
}


hitmarkerbind(bind)
{
    self endon("stophitmarker");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self setclientomnvar("damage_feedback","standard");
    }
}


damagebind(bind)
{
    self endon("stopdamage");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self dodamage(self.health / 2,self.origin);
    }
}


botemp()
{
    foreach(player in level.players)
    if(player != self)
    {
        player [[level.killstreakfuncs["emp"]]]( 0, 0 );
        break;
    }
}


empbind(bind)
{
    self endon("stopemp");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self botemp();
    }
}


predbind(bind)
{
    self endon("stoppred");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self thread [[level.killstreakfuncs["missile_strike"]]](0,0);
            self FreezeControls(false);
        }
    }
}


fadetoblackbind(bind)
{
    self endon("stopfadetoblack");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            x = self createRectangle("CENTER", "CENTER", 0, 0, 900, 900, (0,0,0), 0, 1, "white");
            x FadeOverTime(0.5);
            x.alpha = 1;
            wait 0.8;
            x Destroy();
        }
    }
}



scavengerbind(bind)
{
    self endon("stopscavenger");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self setclientomnvar("damage_feedback","scavenger");
            if(getdvar("realscavenger") == "[ON]")
            {
                dagun = self GetCurrentWeapon();
                self SetWeaponAmmoClip(dagun, 0);
                self SetWeaponAmmoStock(dagun, 9999);
                self SetSpawnWeapon(dagun);
            }
        }
    }
}


togglerealscavenger()
{
    if(getdvar("realscavenger") == "[OFF]")
    setdvar("realscavenger","[ON]");
    else
    setdvar("realscavenger","[OFF]");
}

changetoclass(classnumber)
{
    self.class = "custom" + classnumber;
	maps\mp\gametypes\_class::setclass(self.class);
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	maps\mp\gametypes\_class::giveandapplyloadout(self.teamname,self.class);
}

ccbbind(bind)
{
    self endon("stopccb");
    daclass = 1;
    if(self.class == "custom1")
    daclass = 2;
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            if(daclass > getdvarint("ccblimit"))
            daclass = 1;
            self changetoclass(daclass);
            if(getdvar("ccbcanswaps") == "[ON]")
            self canswap();
            daclass++;
        }
    }
}

changeccblimit()
{
    limit = getdvarint("ccblimit");
    limit++;
    if(limit > 10)
    limit = 2;
    setdvar("ccblimit",limit);
}

toggleccbcanswaps()
{
    if(getdvar("ccbcanswaps") == "[OFF]")
    setdvar("ccbcanswaps","[ON]");
    else
    setdvar("ccbcanswaps","[OFF]");
}


changeeqbindweapon()
{
    if(getdvar("eqweapon") == "airdrop_marker_mp")
    setdvar("eqweapon","agent_mp");
    else if(getdvar("eqweapon") == "agent_mp")
    setdvar("eqweapon","gamemode_ball");
    else if(getdvar("eqweapon") == "gamemode_ball")
    setdvar("eqweapon","s1_tactical_insertion_device_mp");
    else if(getdvar("eqweapon") == "s1_tactical_insertion_device_mp")
    setdvar("eqweapon","exoshield_equipment_mp");
    else if(getdvar("eqweapon") == "exoshield_equipment_mp")
    setdvar("eqweapon","adrenaline_mp");
    else if(getdvar("eqweapon") == "adrenaline_mp")
    setdvar("eqweapon","search_dstry_bomb_defuse_mp");
    else if(getdvar("eqweapon") == "search_dstry_bomb_defuse_mp")
    setdvar("eqweapon","deployable_vest_marker_mp");
    else if(getdvar("eqweapon") == "deployable_vest_marker_mp")
    setdvar("eqweapon","killstreak_missile_strike_mp");
    else if(getdvar("eqweapon") == "killstreak_missile_strike_mp")
    setdvar("eqweapon","killstreak_predator_missile_mp");
    else if(getdvar("eqweapon") == "killstreak_predator_missile_mp")
    setdvar("eqweapon","airdrop_marker_mp");
}


toggleeqdoswap()
{
    if(getdvar("eqdoswap") == "[OFF]")
    setdvar("eqdoswap","[ON]");
    else 
    setdvar("eqdoswap","[OFF]");
}

doequipment()
{
    current = self GetCurrentWeapon();
    self SetSpawnWeapon(current);
    self takeweapongood(current);
    self giveweapon(getdvar("eqweapon"));
    self SwitchToWeapon(getdvar("eqweapon"));
    waitframe();
    waitframe();
    self giveweapongood(current);
    if(getdvar("eqdoswap") == "[ON]")
    self SwitchToWeapon(current);
}

equipmentbind(bind)
{
    self endon("stopequipment");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self doequipment();
    }
}


boltbind(bind)
{
    self endon("stopbolt");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self dobolt();
    }
}

savebolt()
{
    x = getdvarint("boltposcount");
    x++;
    setdvar("boltpos" + x,self getorigin());
    setdvar("boltposcount",x);
    IPrintLnBold("Position " + x + " Saved " + self GetOrigin());
}

deletebolt()
{
    if(getdvarint("boltposcount") > 0)
    setdvar("boltposcount",getdvarint("boltposcount") - 1);
    else
    IPrintLnBold("No Positions Saved");
}

dobolt()
{
    if(getdvarint("boltposcount") == 0)
    {
        IPrintLnBold("No Positions Saved");
        return;
    }

    boltModel = spawn("script_model", self.origin);
    boltModel SetModel("tag_origin");
    self PlayerLinkTo(boltModel);
    for(i=1;i<getdvarint("boltposcount") + 1;i++)
    {
        boltModel MoveTo(getdvarvector("boltpos" + i), GetDvarFloat("boltspeed") / getdvarint("boltposcount"), 0, 0);
        wait GetDvarFloat("boltspeed") / getdvarint("boltposcount");
    }
    self Unlink();
    boltModel delete();
}

changeboltspeed()
{
    speed = getdvarfloat("boltspeed");
    speed += 0.25;
    if(speed > 5)
    speed = 0.25;
    setdvar("boltspeed",speed);
}


playmovementbind(bind)
{
    self endon("stopplaymovement");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self playmovement();
    }
}


recordmovement()
{
    setdvar("recordedpoints",0);

    IPrintLnBold("Move To Record Melee To Stop");
    x = self GetOrigin();
    while(Distance(x, self.origin) < 10)
    waitframe();

    while(!self MeleeButtonPressed())
    {
        x = GetDvarInt("recordedpoints");
        x++;
        setdvar("recordedpos" + x,self GetOrigin());
        setdvar("recordedpoints",x);
        IPrintLnBold("Position " + x + " Recorded");
        waitframe();
    }
}


deleterecordedpoints()
{
    if(getdvarint("recordedpoints") > 0)
    setdvar("recordedpoints",getdvarint("recordedpoints") - 1);
    else
    IPrintLnBold("No Points Recorded");
}

playmovement()
{
    if(getdvarint("recordedpoints") == 0)
    {
        IPrintLnBold("No Points Recorded");
        return;
    }
    boltModel = spawn("script_model", self.origin);
    boltModel SetModel("tag_origin");
    self PlayerLinkTo(boltModel);
    for(i=1;i<getdvarint("recordedpoints") + 1;i++)
    {
        boltModel moveto(getdvarvector("recordedpos" + i),0.06,0,0);
        waitframe();
    }
    self unlink();
    boltModel delete();
}


malabind(bind)
{
    self endon("stopmala");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setweaponflag(2);
    }
}


smoothbind(bind)
{
    self endon("stopsmooth");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self setanimboth(1);
    }
}

setanimboth(int)
{
    self SetSpawnWeapon(self GetCurrentWeapon());
    setanimright(int);
    setanimleft(int);
}


meleebind(bind)
{
    self endon("stopmelee");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(10);
    }
}

lungebind(bind)
{
    self endon("stoplunge");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(12);
    }
}

reloadbind(bind)
{
    self endon("stopreload");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(20);
    }
}

emptyreloadbind(bind)
{
    self endon("stopemptyreload");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(21);
    }
}

fastreloadbind(bind)
{
    self endon("stopfastreload");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(24);
    }
}

sprintinbind(bind)
{
    self endon("stopsprintin");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(32);
    }
}

sprintloopbind(bind)
{
    self endon("stopsprintloop");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(35);
    }
}

mantlebind(bind)
{
    self endon("stopmantle");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(51);
    }
}

slideinbind(bind)
{
    self endon("stopslidein");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(70);
    }
}

slidestallbind(bind)
{
    self endon("stopslidestall");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        setanimboth(71);
    }
}

glidebind(bind)
{
    self endon("stopglide");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            setanimboth(32);
            wait 0.2;
            setanimboth(34);
        }
    }
}




predvisionbind(bind)
{
    self endon("stoppredvision");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self setclientomnvar("ui_predator_missile",1);
            self waittill(bind);
            self setclientomnvar("ui_predator_missile",0);
        }
    }
}

//self setclientomnvar("ui_recondrone_toggle",1);

reconvisionbind(bind)
{
    self endon("stopreconvision");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self setclientomnvar("ui_recondrone_toggle",1);
            self waittill(bind);
            self setclientomnvar("ui_recondrone_toggle",0);
        }
    }
}

//self setclientomnvar("ui_orbital_laser",1);
//self setclientomnvar("ui_orbital_laser_mode",1);

vucanvisionbind(bind)
{
    self endon("stopvucanvision");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        {
            self setclientomnvar("ui_orbital_laser",1);
            self setclientomnvar("ui_orbital_laser_mode",1);
            self waittill(bind);
            self setclientomnvar("ui_orbital_laser",0);
            self setclientomnvar("ui_orbital_laser_mode",0);
        }
    }
}



nacnextbind(bind)
{
    self endon("stopnacnext");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self nacto(self getnextweapon());
    }
}

instaswapnextbind(bind)
{
    self endon("stopinstaswapnext");
    while(true)
    {
        self waittill(bind);
        if(!self isinmenu())
        self instaswapto(self getnextweapon());
    }
}



togglebarriers()
{
    if(getdvar("deathbarriers") == "[ON]")
    {
        setdvar("deathbarriers","[OFF]");
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )
        if(isSubStr(ents[index].classname, "trigger_hurt"))
        ents[index].origin = (0,0,999999);
    }
    else
    {
        setdvar("deathbarriers","[ON]");
        ents = getEntArray();
        for ( index = 0; index < ents.size; index++ )
        if(isDefined(ents[index].oldori) && isSubStr(ents[index].classname, "trigger_hurt"))
        ents[index].origin = ents[index].oldori;
    }
}