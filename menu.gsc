#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\main;
#include scripts\utils;
#include scripts\functions;



menuinit()
{
    self.menu = SpawnStruct();
    self.hud = SpawnStruct();
    self.menu.isopen = false;
    self.smoothscroll = false;
    self.scrolly = -100;
    self structure();
    self thread buttons();
}

buttons()
{
    self endon("death");
    while(true)
    {
        if(!self.menu.isopen)
        {
            if(self adsbuttonpressed() && self isButtonPressed("+actionslot 1"))
            {
                self.menu.isopen = true;
                self load_menu("main");
                self notify("menuopened");
                wait 0.1;
            }
        }
        else
        {
            if(self isButtonPressed("+actionslot 1"))
            {
                self.scroll--;
                self update_scroll();
                wait .1;
            }
            
            if(self isButtonPressed("+actionslot 2"))
            {
                self.scroll++;
                self update_scroll();

                wait .1;
            }
            
            if(self usebuttonpressed())
            { 
                self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],self.menu.input[self.menu.current][self.scroll],self.menu.input2[self.menu.current][self.scroll]);
                self notify("selectedoption");    
                self structure();
                self load_menu(self.menu.current);    
                wait .2;
            }
            
            if(self meleebuttonpressed())
            {
                if(self.menu.parent[self.menu.current] == "exit")
                {
                    self DestroyHud();
                    self.menu.isopen = false;
                    self notify("closedmenu");
                }
                else
                {
                    self load_menu(self.menu.parent[self.menu.current]);
                    waitframe();
                }

                wait .2;
            }
        }
        waitframe();
    }
}

update_scroll()
{
    if ( self.scroll < 0 )
        self.scroll = self.menu.text[self.menu.current].size - 1;

    if ( self.scroll > self.menu.text[self.menu.current].size - 1 )
        self.scroll = 0;

    if ( !isdefined( self.menu.text[self.menu.current][self.scroll - 4] ) || self.menu.text[self.menu.current].size <= 8 )
    {
        for ( i = 0; i < 8; i++ )
        {
            if ( isdefined( self.menu.text[self.menu.current][i] ) )
                self.hud.option[i] = self.menu.text[self.menu.current][i];
            else
                self.hud.option[i] = "";
                
        }

        self.hud.option[self.scroll] = "^5" + self.menu.text[self.menu.current][self.scroll];
    }
    else if ( isdefined( self.menu.text[self.menu.current][self.scroll + 4] ) )
    {
        index = 0;

        for ( i = self.scroll - 4; i < self.scroll + 4; i++ )
        {
            if ( isdefined( self.menu.text[self.menu.current][i] ) )
                self.hud.option[index] = self.menu.text[self.menu.current][i];
            else
                self.hud.option[index] = "  ";
            index++;
        }

        self.hud.option[4] = "^5" + self.menu.text[self.menu.current][self.scroll];

    }
    else
    {
        for ( i = 0; i < 8; i++ )
        {
            self.hud.option[i] = self.menu.text[self.menu.current][self.menu.text[self.menu.current].size + i - 8];
        }
        self.hud.option[self.scroll - self.menu.text[self.menu.current].size + 8] = "^5" + self.menu.text[self.menu.current][self.scroll];

    }

    self thread buildbase(self.hud.option[0],self.hud.option[1],self.hud.option[2],self.hud.option[3],self.hud.option[4],self.hud.option[5],self.hud.option[6],self.hud.option[7]);
}


buildbase(option1,option2,option3,option4,option5,option6,option7,option8)
{
    self notify("stopballs");
    self endon("stopballs");
    saynoname(option1);
    saynoname(option2);
    saynoname(option3);
    saynoname(option4);
    saynoname(option5);
    saynoname(option6);
    saynoname(option7);
    saynoname(option8);
    while(true)
    {
        saynoname(option1);
        saynoname(option2);
        saynoname(option3);
        saynoname(option4);
        saynoname(option5);
        saynoname(option6);
        saynoname(option7);
        saynoname(option8);
        wait 1;
    }
}

destroyhud()
{
    self notify("stopballs");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    saynoname(" ");
    setdvar("cg_chattime",0.01);
    waitframe();
    setdvar("cg_chattime",12000);
}

Structure()
{
    self create_menu("main", "exit");
    self add_option("main",  "Misc", ::load_menu,undefined,"Misc");
    self add_option("main",  "Toggles", ::load_menu,undefined,"Toggles");
    self add_option("main",  "Aimbot", ::load_menu,undefined,"Aimbot");
    self add_option("main",  "Weapons", ::load_menu,undefined,"Weapons");
    self add_option("main",  "Score Streaks", ::load_menu,undefined,"Scorestreaks");
    self add_option("main",  "Binds", ::load_menu,undefined,"Binds");
    self add_option("main",  "Lobby", ::load_menu,undefined,"Lobby");
    self add_option("main",  "Players", ::load_menu,undefined,"Players");

    self create_menu("Binds", "main");
    self add_option("Binds",  "Animations", ::load_menu,undefined,"Animations");
    self add_option("Binds",  "Nac Mod", ::load_menu,undefined,"Nac Mod");
    self add_option("Binds",  "Instaswap", ::load_menu,undefined,"Instaswap");
    self add_option("Binds",  "Scavenger", ::load_menu,undefined,"Scavenger");
    self add_option("Binds",  "Change Class", ::load_menu,undefined,"Change Class");
    self add_option("Binds",  "Equipment", ::load_menu,undefined,"Equipment");
    self add_option("Binds",  "Bolt Movement", ::load_menu,undefined,"Bolt Movement");
    self add_option("Binds",  "Record Movement", ::load_menu,undefined,"Record Movement");
    self add_bind("Binds", "Canswap", ::canswapbind, "canswap");
    self add_bind("Binds", "Illusion Canswap", ::illusioncanswapbind, "illusioncanswap");
    self add_bind("Binds", "Illusion", ::illusionbind, "illusion");
    self add_bind("Binds", "Houdini", ::houdinibind, "houdini");
    self add_bind("Binds", "STZ Tilt", ::stztiltbind, "stztiltbind");
    self add_bind("Binds", "Vish", ::vishbind, "vish");
    self add_bind("Binds", "Mala", ::malabind, "mala");
    self add_bind("Binds", "Gunlock", ::gunlockbind, "gunlock");
    self add_bind("Binds", "Flash", ::flashbind, "flash");
    self add_bind("Binds", "Hitmarker", ::hitmarkerbind, "hitmarker");
    self add_bind("Binds", "Damage", ::damagebind, "damage");
    self add_bind("Binds", "EMP", ::empbind, "emp");
    self add_bind("Binds", "Pred", ::predbind, "pred");
    self add_bind("Binds", "Fade To Black", ::fadetoblackbind, "fadetoblack");
    self add_bind("Binds", "Pred Vision", ::predvisionbind, "predvision");
    self add_bind("Binds", "Recon Vision", ::reconvisionbind, "reconvision");
    self add_bind("Binds", "Vucan Vision", ::vucanvisionbind, "vucanvision");

    self create_menu("Animations", "Binds");
    self add_bind("Animations", "Smooth", ::smoothbind, "smooth");
    self add_bind("Animations", "Melee", ::meleebind, "melee");
    self add_bind("Animations", "Lunge", ::lungebind, "lunge");
    self add_bind("Animations", "Reload", ::reloadbind, "reload");
    self add_bind("Animations", "Empty Reload", ::emptyreloadbind, "emptyreload");
    self add_bind("Animations", "Fast Reload", ::fastreloadbind, "fastreload");
    self add_bind("Animations", "Sprint In", ::sprintinbind, "sprintin");
    self add_bind("Animations", "Sprint Loop", ::sprintloopbind, "sprintloop");
    self add_bind("Animations", "Glide", ::glidebind, "glide");
    self add_bind("Animations", "Mantle", ::mantlebind, "mantle");
    self add_bind("Animations", "Slide In", ::slideinbind, "slidein");
    self add_bind("Animations", "Slide Stall", ::slidestallbind, "slidestall");

    self create_menu("Record Movement", "Binds");
    self add_bind("Record Movement", "Bind", ::playmovementbind, "playmovement");
    self add_option("Record Movement",  "Record Movement", ::recordmovement);
    self add_option("Record Movement",  "Delete Last Point", ::deleterecordedpoints, "[" + getdvarint("recordedpoints") + "]");

    self create_menu("Bolt Movement", "Binds");
    self add_bind("Bolt Movement", "Bind", ::boltbind, "bolt");
    self add_option("Bolt Movement",  "Save Postion", ::savebolt);
    self add_option("Bolt Movement",  "Delete Postion", ::deletebolt, "[" + getdvarint("boltposcount") + "]");
    self add_option("Bolt Movement",  "Speed", ::changeboltspeed, "[" + getdvarfloat("boltspeed") + "]");

    self create_menu("Equipment", "Binds");
    self add_bind("Equipment", "Bind", ::equipmentbind, "equipment");
    self add_option("Equipment",  "Weapon", ::changeeqbindweapon,"[" + getdvar("eqweapon") + "]");
    self add_option("Equipment",  "Instant Swap", ::toggleeqdoswap,getdvar("eqdoswap"));

    self create_menu("Change Class", "Binds");
    self add_bind("Change Class", "Bind", ::ccbbind, "ccb");
    self add_option("Change Class",  "Wrap Limit", ::changeccblimit,"[" + getdvarint("ccblimit") + "]");
    self add_option("Change Class",  "Canswaps", ::toggleccbcanswaps,getdvar("ccbcanswaps"));

    self create_menu("Scavenger", "Binds");
    self add_bind("Scavenger", "Bind", ::scavengerbind, "scavenger");
    self add_option("Scavenger",  "Real Scavenger", ::togglerealscavenger,getdvar("realscavenger"));

    self create_menu("Instaswap", "Binds");
    self add_option("Instaswap",  "First Weapon", ::selectfirstinstaswap,getdvar("firstinstaswap"));
    self add_option("Instaswap",  "Second Weapon", ::selectsecondinstaswap,getdvar("secondinstaswap"));
    self add_bind("Instaswap", "Bind", ::instaswapbind, "instaswap");
    self add_bind("Instaswap", "Instaswap To Next Weapon", ::instaswapnextbind, "instaswapnext");

    self create_menu("Nac Mod", "Binds");
    self add_option("Nac Mod",  "First Weapon", ::selectfirstnac,getdvar("firstnac"));
    self add_option("Nac Mod",  "Second Weapon", ::selectsecondnac,getdvar("secondnac"));
    self add_bind("Nac Mod", "Bind", ::nacmodbind, "nacmod");
    self add_bind("Nac Mod", "Nac To Next Weapon", ::nacnextbind, "nacnext");

    self create_menu("Weapons", "main");
    self add_option("Weapons", "Refill Ammo", ::refilldaammo);
    self add_option("Weapons", "Drop Weapon", ::dropcurrent);
    self add_option("Weapons", "Take Weapon", ::takecurrent);
    self add_option("Weapons", "Attachments", ::load_menu,undefined,"Attachments");
    self add_option("Weapons","Assault rifles", ::load_menu,undefined, "Assault rifles");
    self add_option("Weapons","Submachine guns", ::load_menu,undefined, "Submachine guns");
    self add_option("Weapons","Sniper rifles", ::load_menu,undefined, "Sniper rifles");
    self add_option("Weapons","Shotguns", ::load_menu,undefined, "Shotguns");
    self add_option("Weapons","Heavy weapons", ::load_menu,undefined, "Heavy weapons");
    self add_option("Weapons","Pistols", ::load_menu,undefined, "Pistols");
    self add_option("Weapons","Launchers", ::load_menu,undefined, "Launchers");
    self add_option("Weapons","Specials", ::load_menu,undefined, "Specials");

    


    self create_menu("Attachments", "Weapons");
    self add_option("Attachments","Lynx scope", ::setattachment,undefined,"gm6scope");
    self add_option("Attachments","Mors scope", ::setattachment,undefined,"morsscope");
    self add_option("Attachments","RW1 scope", ::setattachment,undefined,"rw1scopebase");
    self add_option("Attachments","Red dot", ::setattachment,undefined,"opticsreddot");
    self add_option("Attachments","Acog", ::setattachment,undefined,"opticsacog2ar");
    self add_option("Attachments","Thermal", ::setattachment,undefined,"opticsthermalar");
    self add_option("Attachments","Heartbeat", ::setattachment,undefined,"heartbeat");
    self add_option("Attachments","Foregrip", ::setattachment,undefined,"foregrip");
    self add_option("Attachments","Silencer", ::setattachment,undefined,"silencer01");
    self add_option("Attachments","Knife", ::setattachment,undefined,"tactical");
    self add_option("Attachments","Akimbo", ::setattachment,undefined,"akimbo");
    self add_option("Attachments","Grenade launcher", ::setattachment,undefined,"gl");

    self create_menu("Scorestreaks", "main");
    self add_option("Scorestreaks","Fill Streaks", ::givedastreaks);
    self add_option("Scorestreaks","Recon Drone", ::giveastreak,undefined,"recon_ugv");
    self add_option("Scorestreaks","UAV", ::giveastreak,undefined,"uav");
    self add_option("Scorestreaks","Assault Drone", ::giveastreak,undefined,"assault_ugv");
    self add_option("Scorestreaks","Carepackage", ::giveastreak,undefined,"orbital_carepackage");
    self add_option("Scorestreaks","Sentry", ::giveastreak,undefined,"remote_mg_sentry_turret");
    self add_option("Scorestreaks","XS1 Vulcan", ::giveastreak,undefined,"orbital_strike_laser");
    self add_option("Scorestreaks","Missile Strike", ::giveastreak,undefined,"missile_strike");
    self add_option("Scorestreaks","EMP", ::giveastreak,undefined,"emp");
    self add_option("Scorestreaks","Bombing Run", ::giveastreak,undefined,"strafing_run_airstrike");
    self add_option("Scorestreaks","XS1 Goliath", ::giveastreak,undefined,"heavy_exosuit");
    self add_option("Scorestreaks","Warbird", ::giveastreak,undefined,"warbird");
    self add_option("Scorestreaks","Paladin", ::giveastreak,undefined,"orbitalsupport");
    self add_option("Scorestreaks","Nuke", ::giveastreak,undefined,"nuke");

    self create_menu("Aimbot", "main");
    self add_option("Aimbot",  "Aimbot", ::toggleaimbot,getdvar("aimbot"));
    if(getdvar("aimbot") != "[UNFAIR]")
    self add_option("Aimbot",  "Aimbot Range", ::changeaimbotrange,"[" + getdvarint("aimbotrange") + "]");
    self add_option("Aimbot",  "Aimbot Weapon", ::selectaimbotweapon,getdvar("aimbotweaponname"));
    self add_option("Aimbot",  "Hitmarker Aimbot", ::togglehitaimbot,getdvar("hitaimbot"));
    self add_option("Aimbot",  "Hitmarker Aimbot Weapon", ::selecthitaimbotweapon,getdvar("hitaimbotweaponname"));

    self create_menu("Misc", "main");
    self add_option("Misc",  "Give vish", ::givevish);
    self add_option("Misc",  "Spawn Helicopter", ::spawndaheli);
    self add_option("Misc",  "Delete Helicopter", ::deletechoppa);
    self add_option("Misc",  "Give Akimbo Primary", ::giveakimbop);
    self add_option("Misc",  "Give Akimbo Secondary", ::giveakimbos);

    self create_menu("Lobby", "main");
    self add_option("Lobby",  "Spawn A Bot", ::spawndumbass);
    self add_option("Lobby",  "Bots To Crosshair", ::alltoch);
    self add_option("Lobby",  "Bots Look At Me", ::botslookatme);
    self add_option("Lobby",  "Kick Bots", ::kickdumbasses);
    self add_option("Lobby",  "Gravity", ::changegravity,"[" + getdvarint("g_gravity") + "]");
    self add_option("Lobby",  "Move Speed", ::changegspeed,"[" + getdvarint("g_speed") + "]");
    self add_option("Lobby",  "Timescale", ::changeslowmo,"[" + getdvarfloat("slowmo") + "]");


    self create_menu("Toggles", "main");
    self add_option("Toggles",  "God Mode", ::togglegodmode,getdvar("godmode"));
    self add_option("Toggles",  "UFO Bind", ::toggleufobind,getdvar("ufobind"));
    self add_option("Toggles",  "Killcam Weapon", ::togglekillcamweapon,getdvar("killcamweapon"));
    self add_option("Toggles",  "Ground Slams", ::toggleslams,getdvar("slams"));
    self add_option("Toggles",  "Instashoot", ::toggleinstashoot,getdvar("instashoot"));
    self add_option("Toggles",  "Always Canswap", ::togglealwayscanswap,getdvar("alwayscanswap"));
    self add_option("Toggles",  "STZ Tilt", ::togglestztilt,getdvar("stztilt"));
    self add_option("Toggles",  "Mid Air Prone", ::togglemidairprone,getdvar("midairprone"));
    self add_option("Toggles",  "Infinite Equipment", ::toggleinfeq,getdvar("infeq"));
    self add_option("Toggles",  "Infinite Ability", ::toggleinfiniteability,getdvar("infiniteability"));

    self create_menu("Assault rifles", "Weapons");
    self add_option("Assault rifles","AE4", ::givedaweapon,undefined,"iw5_dlcgun1_mp");
    self add_option("Assault rifles","STG44", ::givedaweapon,undefined,"iw5_dlcgun6_mp");
    self add_option("Assault rifles","AK-47", ::givedaweapon,undefined,"iw5_dlcgun7loot7_mp");
    self add_option("Assault rifles","M16", ::givedaweapon,undefined,"iw5_dlcgun7loot6_mp");
    self add_option("Assault rifles","M1 Garand", ::givedaweapon,undefined,"iw5_dlcgun23_mp");
    self add_option("Assault rifles","Lever Action", ::givedaweapon,undefined,"iw5_dlcgun33_mp");
    self add_option("Assault rifles","Bal-27", ::givedaweapon,undefined,"iw5_bal27_mp");
    self add_option("Assault rifles","AK-12", ::givedaweapon,undefined,"iw5_ak12_mp");
    self add_option("Assault rifles","ARX-160", ::givedaweapon,undefined,"iw5_arx160_mp");
    self add_option("Assault rifles","HBRa3", ::givedaweapon,undefined,"iw5_hbra3_mp");
    self add_option("Assault rifles","IMR", ::givedaweapon,undefined,"iw5_himar_mp");
    self add_option("Assault rifles","MK14", ::givedaweapon,undefined,"iw5_m182spr_mp");

    self create_menu("Submachine guns", "Weapons");
    self add_option("Submachine guns","MP40", ::givedaweapon,undefined,"iw5_dlcgun18_mp");
    self add_option("Submachine guns","Sten", ::givedaweapon,undefined,"iw5_dlcgun28_mp");
    self add_option("Submachine guns","Repulsor", ::givedaweapon,undefined,"iw5_dlcgun38_mp");
    self add_option("Submachine guns","KF5", ::givedaweapon,undefined,"iw5_kf5_mp");
    self add_option("Submachine guns","MP11", ::givedaweapon,undefined,"iw5_mp11_mp");
    self add_option("Submachine guns","ASM1", ::givedaweapon,undefined,"iw5_asm1_mp");
    self add_option("Submachine guns","SN6", ::givedaweapon,undefined,"iw5_sn6_mp");
    self add_option("Submachine guns","SAC3", ::givedaweapon,undefined,"iw5_sac3_mp_akimbo");
    self add_option("Submachine guns","AMR9", ::givedaweapon,undefined,"iw5_hmr9_mp");

    self create_menu("Sniper rifles", "Weapons");
    self add_option("Sniper rifles","SVO", ::givedaweapon,undefined,"iw5_dlcgun6loot5_mp_dragunovdlcscope");
    self add_option("Sniper rifles","Lynx", ::givedaweapon,undefined,"iw5_gm6_mp_gm6scope");
    self add_option("Sniper rifles","MORS", ::givedaweapon,undefined,"iw5_mors_mp_morsscope");
    self add_option("Sniper rifles","NA-45", ::givedaweapon,undefined,"iw5_m990_mp_m990scope");
    self add_option("Sniper rifles","Atlas 20mm", ::givedaweapon,undefined,"iw5_thor_mp_thorscope");

    self create_menu("Shotguns", "Weapons");
    self add_option("Shotguns","CEL-3", ::givedaweapon,undefined,"iw5_dlcgun8loot1_mp");
    self add_option("Shotguns","Blunderbuss", ::givedaweapon,undefined,"iw5_dlcgun4_mp");
    self add_option("Shotguns","Tac-19", ::givedaweapon,undefined,"iw5_uts19_mp");
    self add_option("Shotguns","S-12", ::givedaweapon,undefined,"iw5_rhino_mp");
    self add_option("Shotguns","Bulldog", ::givedaweapon,undefined,"iw5_maul_mp");

    self create_menu("Heavy weapons", "Weapons");
    self add_option("Heavy weapons","Ohm", ::givedaweapon,undefined,"iw5_dlcgun2_mp_sensorheartbeat");
    self add_option("Heavy weapons","EM1", ::givedaweapon,undefined,"iw5_em1_mp");
    self add_option("Heavy weapons","Pytaek", ::givedaweapon,undefined,"iw5_lsat_mp");
    self add_option("Heavy weapons","XMG", ::givedaweapon,undefined,"iw5_exoxmg_mp_akimboxmg");
    self add_option("Heavy weapons","EPM3", ::givedaweapon,undefined,"iw5_epm3_mp");
    self add_option("Heavy weapons","Ameli", ::givedaweapon,undefined,"iw5_asaw_mp");

    self create_menu("Specials", "Weapons");
    self add_option("Specials","M1 Irons", ::givedaweapon,undefined,"iw5_dlcgun3_mp");
    self add_option("Specials","M1 Irons akimbo", ::givedaweapon,undefined,"iw5_dlcgun3_mp_akimbo");
    self add_option("Specials","Heavy Shield", ::givedaweapon,undefined,"iw5_riotshieldt6_mp");
    self add_option("Specials","MDL", ::givedaweapon,undefined,"iw5_microdronelauncher_mp");
    self add_option("Specials","Crossbow", ::givedaweapon,undefined,"iw5_exocrossbow_mp");
    self add_option("Specials","Mw3 shield", ::givespecial,undefined,"riotshield_mp");
    self add_option("Specials","Javelin", ::givespecial,undefined,"paint_missile_killstreak_mp");
    self add_option("Specials","Mw3 carepackage", ::givespecial,undefined,"airdrop_marker_mp");
    self add_option("Specials","Ballistic vest", ::givespecial,undefined,"deployable_vest_marker_mp");
    self add_option("Specials","Rhand throwing knife", ::givespecial,undefined,"throwingknife_rhand_mp");
    self add_option("Specials","Mw3 grenade", ::givespecial,undefined,"airdrop_trap_explosive_mp");

    self create_menu("Pistols", "Weapons");
    self add_option("Pistols","1911", ::givedaweapon,undefined,"iw5_dlcgun13_mp");
    self add_option("Pistols","1911 akimbo", ::givedaweapon,undefined,"iw5_dlcgun13_mp_akimbo");
    self add_option("Pistols","Atlas 45", ::givedaweapon,undefined,"iw5_titan45_mp");
    self add_option("Pistols","Atlas 45 akimbo", ::givedaweapon,undefined,"iw5_titan45_mp_akimbo");
    self add_option("Pistols","MP443", ::givedaweapon,undefined,"iw5_pbw_mp");
    self add_option("Pistols","MP443 akimbo", ::givedaweapon,undefined,"iw5_pbw_mp_akimbo");
    self add_option("Pistols","PDW", ::givedaweapon,undefined,"iw5_vbr_mp");
    self add_option("Pistols","PDW akimbo", ::givedaweapon,undefined,"iw5_vbr_mp_akimbo");
    self add_option("Pistols","RW1", ::givedaweapon,undefined,"iw5_rw1_mp");

    self create_menu("Launchers", "Weapons");
    self add_option("Launchers","Stinger M7", ::givedaweapon,undefined,"iw5_stingerm7_mp");
    self add_option("Launchers","MAAWS", ::givedaweapon,undefined,"iw5_maaws_mp");
    self add_option("Launchers","MAHEM", ::givedaweapon,undefined,"iw5_mahem_mp_mahemscopebase");

    self create_menu("Players", "main");
    foreach(player in level.players)
    {
        self add_option("Players",  player.name, ::load_menu,undefined,player.name);

        self create_menu(player.name, "Players");
        self add_option(player.name,  "To Crosshair", ::playertoch,undefined,player);
        self add_option(player.name,  "Kick", ::kickdumbass,undefined,player);
    }
}

placeholder()
{
IPrintLnBold(self.scroll + 1);
}