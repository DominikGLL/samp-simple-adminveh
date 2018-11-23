#include <a_samp>
#include <YSI\y_hooks>
#include <utils>
#include <zcmd>
#pragma unused ReturnUser

new AdminVeh[MAX_PLAYERS] = INVALID_VEHICLE_ID,
	engine, lights,
	alarm, doors,
	bonnet, boot,
	objective;

COMMAND:aveh(playerid, params[])return cmd_adminveh(playerid, params);
COMMAND:adminveh(playerid, params[])
{
	if(AdminVeh[playerid] != INVALID_VEHICLE_ID)
	{
	    DestroyVehicle(AdminVeh[playerid]);
	    AdminVeh[playerid] = INVALID_VEHICLE_ID;
	    return SendClientMessage(playerid, -1, "Adminfahrzeug gel�scht!");
	}
	if(isnull(params))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/adminveh [Fahrzeug ID]");
	if(!IsNumeric(params))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}/adminveh [Fahrzeug ID]");
	if(strval(params) < 400 || strval(params) > 611)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Ung�ltige Fahrzeug ID.");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    AdminVeh[playerid] = CreateVehicle(strval(params), x+0.5, y+0.5, z, 80.000, 7, 7, -1);
    PutPlayerInVehicle(playerid, AdminVeh[playerid], 0);
    GetVehicleParamsEx(AdminVeh[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(AdminVeh[playerid], VEHICLE_PARAMS_ON, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
    return SendClientMessage(playerid, -1, "{006DFF}INFO: {FFFFFF}Adminfahrzeug erstellt!");
}
COMMAND:alock(playerid, params[])return cmd_adminvehlock(playerid, params);
COMMAND:adminvehlock(playerid, params[])
{
	if(AdminVeh[playerid] != INVALID_VEHICLE_ID)return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Du besitzt kein Fahrzeug!");
	new Float:vehx, Float:vehy, Float:vehz, string[128];
 	GetVehiclePos(AdminVeh[playerid], vehx, vehy, vehz);
 	if(!IsPlayerInRangeOfPoint(playerid, 5.0, vehx, vehy, vehz))return SendClientMessage(playerid, -1, "{FF0000}FEHLER: {FFFFFF}Dein Adminfahrzeug ist nicht in deiner N�he!");
 	GetVehicleParamsEx(AdminVeh[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
 	if(doors) SetVehicleParamsEx(AdminVeh[playerid], engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
 	else SetVehicleParamsEx(AdminVeh[playerid], engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
 	format(string, sizeof(string),"{006DFF}INFO: {FFFFFF}Du hast dein Adminfahrzeug %s.",(doors) ? ("abgeschlossen") : ("aufgeschlossen"));
	return SendClientMessage(playerid, -1, string);
}

hook OnPlayerConnect(playerid)
{
    AdminVeh[playerid] = INVALID_VEHICLE_ID;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(AdminVeh[playerid] != INVALID_VEHICLE_ID)
	{
	    DestroyVehicle(AdminVeh[playerid]);
	    AdminVeh[playerid] = INVALID_VEHICLE_ID;
	}
	return 1;
}