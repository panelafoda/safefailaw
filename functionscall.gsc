#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\utils;
#include scripts\menu;
#include scripts\main;
#include scripts\functions;





functionscall()
{
    if(getdvar("godmode") == "[ON]")
    executecommand("god");

    if(getdvar("alwayscanswap") != "[OFF]")
    {
        if(getdvar("alwayscanswap") == "[ALL]")
        self thread alwayscanswapallloop();
        else
        self thread alwayscanswapspecificloop();
    }

    if(getdvar("instashoot") != "[OFF]")
    {
        if(getdvar("instashoot") == "[ALL]")
        self thread allinstashoot();
        else
        self thread specificinstashoot();
    }

    if(getdvar("stztilt") == "[ON]")
    self setangles((self.angles[0],self.angles[1],180));

    if(getdvar("midairprone") == "[ON]")
    self thread midairproneloop();

    if(getdvar("slams") == "[ON]")
    self playerallowhighjumpdrop(1);
    else
    self playerallowhighjumpdrop(0);

    if(getdvar("infeq") == "[ON]")
    self thread infeqloop();

    if(getdvar("infiniteability") == "[ON]")
    self thread infiniteabilityloop();

    if(getdvar("aimbot") == "[NORMAL]")
    self thread normalaimbotloop();
    else if(getdvar("aimbot") == "[UNFAIR]")
    self thread unfairaimbotloop();

    if(getdvar("hitaimbot") == "[ON]")
    self thread hitaimbotloop();

}