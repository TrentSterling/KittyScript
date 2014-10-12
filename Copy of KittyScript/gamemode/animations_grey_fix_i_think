
------
-- NPC Animations
-- March 24, 2007
-- Rick Darkaliono
------


--Weapons that are always aimed
AlwaysAimed = 
{

	"weapon_physgun",
	"weapon_physcannon",
	"weapon_frag",
	"weapon_slam",
	"weapon_rpg",
	"gmod_tool"

}

--Weapons that are never aimed
NeverAimed =
{

	"ts_keys",
	"weapon_ts_zipties",
	"ts_medic",
	"ts_search",
	"weapon_ts_gloves"

}

--Weapons that can still be usable while not aimed
UsableHolstered =
{

	"ts_keys",
	"weapon_ts_zipties",
	"ts_medic",
	"ts_search",
	"weapon_ts_gloves",
	"weapon_cloak"

}

Models = {
	          "models/Humans/Group01/Male_01.mdl",
              "models/Humans/Group01/male_02.mdl",
              "models/Humans/Group01/male_03.mdl",
              "models/Humans/Group01/Male_04.mdl",
              "models/Humans/Group01/Male_05.mdl",
              "models/Humans/Group01/male_06.mdl",
              "models/Humans/Group01/male_07.mdl",
              "models/Humans/Group01/male_08.mdl",
              "models/Humans/Group01/male_09.mdl",
              "models/Humans/Group02/Male_01.mdl",
              "models/Humans/Group02/male_02.mdl",
              "models/Humans/Group02/male_03.mdl",
              "models/Humans/Group02/Male_04.mdl",
              "models/Humans/Group02/Male_05.mdl",
              "models/Humans/Group02/male_06.mdl",
              "models/Humans/Group02/male_07.mdl",
              "models/Humans/Group02/male_08.mdl",
              "models/Humans/Group02/male_09.mdl",
			  "models/zombie/fast.mdl",
			  "models/vortigaunt.mdl",
			  "models/vortigaunt_slave.mdl",

              "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl",

}

function ccModelList( ply, cmd, args )

	ply:PrintMessage( 2, "USE rp_setmodel TO CHANGE MODEL. HERE ARE THE MODELS AVAILABLE: " );
	
	for k, v in pairs( Models ) do
	
		ply:PrintMessage( 2, v );
	
	end

end
--concommand.Add( "rp_modellist", ccModelList );

function ccSetModel( ply, cmd, args )

	for k, v in pairs( Models ) do
	
		if( v == args[1] ) then
			ply:GetTable().NextModel = args[1];
			ply:PrintMessage( 2, "Model will be changed on next spawn" );
			return;
		end
	
	end
	
	ply:PrintMessage( 2, "No such model: " .. args[1] );

end
--concommand.Add( "rp_setmodel", ccSetModel );

function HolsterToggle( ply )

	if( !NPC_ANIMS_ENABLED ) then return; end

	if( !ply:GetActiveWeapon():IsValid() ) then
		return;
	end
	
	local weap = ply:GetActiveWeapon();

	if( ply:GetNWInt( "holstered" ) == 1 ) then
		
		for j, l in pairs( NeverAimed ) do
			
			if( l == weap:GetClass() ) then
				return;
			end
			
		end

		if( ply:GetActiveWeapon() == weapon_ts_stunstick ) then
			//ply:EmitSound("weapons\stunstick\spark2.wav");
			ply:EmitSound( Sound( "weapons\stunstick\spark2.wav" ) );
		end

		MakeAim( ply );
	else
		
		for j, l in pairs( AlwaysAimed ) do
			
			if( l == weap:GetClass() ) then
				return;
			end
			
		end

		if( ply:GetActiveWeapon() == weapon_ts_stunstick ) then
			//ply:EmitSound("weapons\stunstick\spark2.wav");
			ply:EmitSound( Sound( "weapons\stunstick\spark3.wav" ) );
		end
		
		MakeUnAim( ply );
	end

end
concommand.Add( "rp_toggleholster", HolsterToggle );

function MakeAim( ply )

	if( !ply:GetActiveWeapon():IsValid() ) then return; end

	if( !ply:GetActiveWeapon():GetTable().Invisible ) then
		ply:DrawViewModel( true );
		ply:DrawWorldModel( true );
	else
		ply:DrawViewModel( false );
		ply:DrawWorldModel( false );
	end
	
	ply:GetActiveWeapon():SetNWBool( "NPCAimed", true );
	ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() );
	
	ply:SetNWInt( "holstered", 0 );
	
	if( ply:GetActiveWeapon().ToggleWeaponHolster ) then
		ply:GetActiveWeapon():ToggleWeaponHolster( true );
	end

	ply:SetField( "WeapAnim", GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 ) );
	

end

function MakeUnAim( ply )

	if( !ply:GetActiveWeapon():IsValid() ) then return; end

	ply:DrawViewModel( false );
	
	if( ply:GetActiveWeapon():IsValid() ) then
		ply:GetActiveWeapon():SetNWBool( "NPCAimed", false );
		
		local delay = true;
		
		for k, v in pairs( UsableHolstered ) do
			if( v == ply:GetActiveWeapon():GetClass() ) then
				delay = false;
			end
		end
		
		if( delay ) then
			ply:GetActiveWeapon():SetNextPrimaryFire( CurTime() + 999999 );
		end
		
		if( ply:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
			ply:GetActiveWeapon():ToggleIronsight();
		end
	end
	
	ply:SetNWInt( "holstered", 1 );
	
	if( ply:GetActiveWeapon().ToggleWeaponHolster ) then
		ply:GetActiveWeapon():ToggleWeaponHolster( false );
	end
	
	ply:SetField( "WeapAnim", GetWeaponAct( ply, ply:Weapon_TranslateActivity( ACT_HL2MP_IDLE ) or -1 ) );
	

end


function NPCPlayerSpawn( ply )

	if( !NPC_ANIMS_ENABLED ) then return; end

	GAMEMODE:PlayerSpawn( ply );

	if( ply:GetTable().NextModel ) then
		ply:SetModel( ply:GetTable().NextModel );
	end
	
	return true;

end
--hook.Add( "PlayerSpawn", "NPCPlayerSpawn", NPCPlayerSpawn );


NPCAnim = { }

NPCAnim.CitizenMaleAnim = { }
NPCAnim.CitizenMaleModels = 
{

	          "models/Humans/Group01/Male_01.mdl",
              "models/Humans/Group01/male_02.mdl",
              "models/Humans/Group01/male_03.mdl",
              "models/Humans/Group01/Male_04.mdl",
              "models/Humans/Group01/Male_05.mdl",
              "models/Humans/Group01/male_06.mdl",
              "models/Humans/Group01/male_07.mdl",
              "models/Humans/Group01/male_08.mdl",
              "models/Humans/Group01/male_09.mdl",
              "models/Humans/Group02/Male_01.mdl",
              "models/Humans/Group02/male_02.mdl",
              "models/Humans/Group02/male_03.mdl",
              "models/Humans/Group02/Male_04.mdl",
              "models/Humans/Group02/Male_05.mdl",
              "models/Humans/Group02/male_06.mdl",
              "models/Humans/Group02/male_07.mdl",
              "models/Humans/Group02/male_08.mdl",
              "models/Humans/Group02/male_09.mdl",
              "models/Humans/Group03/Male_01.mdl",
              "models/Humans/Group03/male_02.mdl",
              "models/Humans/Group03/male_03.mdl",
              "models/Humans/Group03/Male_04.mdl",
              "models/Humans/Group03/Male_05.mdl",
              "models/Humans/Group03/male_06.mdl",
              "models/Humans/Group03/male_07.mdl",
              "models/Humans/Group03/male_08.mdl",
              "models/Humans/Group03/male_09.mdl",
              "models/Humans/Group03m/Male_01.mdl",
              "models/Humans/Group03m/male_02.mdl",
              "models/Humans/Group03m/male_03.mdl",
              "models/Humans/Group03m/Male_04.mdl",
              "models/Humans/Group03m/Male_05.mdl",
              "models/Humans/Group03m/male_06.mdl",
              "models/Humans/Group03m/male_07.mdl",
              "models/Humans/Group03m/male_08.mdl",
              "models/Humans/Group03m/male_09.mdl",
			  "models/zombie/fast.mdl",
			  "models/vortigaunt.mdl",
			  "models/vortigaunt_slave.mdl"
 
}

for k, v in pairs( NPCAnim.CitizenMaleModels ) do

	NPCAnim.CitizenMaleModels[k] = string.lower( v );

end


NPCAnim.CitizenMaleAnim["idle"] = 1
NPCAnim.CitizenMaleAnim["walk"] = 6
NPCAnim.CitizenMaleAnim["run"] = 10
NPCAnim.CitizenMaleAnim["glide"] = 27
NPCAnim.CitizenMaleAnim["sit"] = 0
NPCAnim.CitizenMaleAnim["crouch"] = 5
NPCAnim.CitizenMaleAnim["crouchwalk"] = 8
 
NPCAnim.CitizenMaleAnim["pistolidle"] = 1
NPCAnim.CitizenMaleAnim["pistolwalk"] = 6
NPCAnim.CitizenMaleAnim["pistolrun"] = 10
NPCAnim.CitizenMaleAnim["pistolcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["pistolcrouch"] = 266
//NPCAnim.CitizenMaleAnim["pistolaimidle"] = 266
NPCAnim.CitizenMaleAnim["pistolaimidle"] = 266
NPCAnim.CitizenMaleAnim["pistolaimwalk"] = 6
NPCAnim.CitizenMaleAnim["pistolaimrun"] = 10
NPCAnim.CitizenMaleAnim["pistolaimcrouch"] = 275
NPCAnim.CitizenMaleAnim["pistolaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["pistolreload"] = 359
NPCAnim.CitizenMaleAnim["pistolfire"] = 266
 
NPCAnim.CitizenMaleAnim["smgidle"] = 1
NPCAnim.CitizenMaleAnim["smgrun"] = 10
NPCAnim.CitizenMaleAnim["smgwalk"] = 6
NPCAnim.CitizenMaleAnim["smgaimidle"] = 266
NPCAnim.CitizenMaleAnim["smgaimwalk"] = 6
NPCAnim.CitizenMaleAnim["smgcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["smgcrouch"] = 5
NPCAnim.CitizenMaleAnim["smgaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["smgaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["smgaimrun"] = 10
NPCAnim.CitizenMaleAnim["smgreload"] = 359
NPCAnim.CitizenMaleAnim["smgfire"] = 266
 
NPCAnim.CitizenMaleAnim["ar2idle"] = 1
NPCAnim.CitizenMaleAnim["ar2walk"] = 6
NPCAnim.CitizenMaleAnim["ar2run"] = 10
NPCAnim.CitizenMaleAnim["ar2aimidle"] = 266
NPCAnim.CitizenMaleAnim["ar2aimwalk"] = 6
NPCAnim.CitizenMaleAnim["ar2aimrun"] = 10
NPCAnim.CitizenMaleAnim["ar2crouchwalk"] = 8
NPCAnim.CitizenMaleAnim["ar2crouch"] = 266
NPCAnim.CitizenMaleAnim["ar2aimcrouch"] = 275
NPCAnim.CitizenMaleAnim["ar2aimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["ar2reload"] = 359
NPCAnim.CitizenMaleAnim["ar2fire"] = 266
 
NPCAnim.CitizenMaleAnim["shotgunidle"] = 1
NPCAnim.CitizenMaleAnim["shotgunwalk"] = 6
NPCAnim.CitizenMaleAnim["shotgunrun"] = 10
NPCAnim.CitizenMaleAnim["shotgunaimidle"] = 266
NPCAnim.CitizenMaleAnim["shotgunaimwalk"] = 6
NPCAnim.CitizenMaleAnim["shotgunaimrun"] = 10
NPCAnim.CitizenMaleAnim["shotguncrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["shotguncrouch"] = 266
NPCAnim.CitizenMaleAnim["shotgunaimcrouch"] = 275
NPCAnim.CitizenMaleAnim["shotgunaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["shotgunreload"] = 359
NPCAnim.CitizenMaleAnim["shotgunfire"] = 266
 
NPCAnim.CitizenMaleAnim["crossbowidle"] = 1
NPCAnim.CitizenMaleAnim["crossbowwalk"] = 6
NPCAnim.CitizenMaleAnim["crossbowrun"] = 10
NPCAnim.CitizenMaleAnim["crossbowaimidle"] = 266
NPCAnim.CitizenMaleAnim["crossbowaimwalk"] = 6
NPCAnim.CitizenMaleAnim["crossbowaimrun"] = 10
NPCAnim.CitizenMaleAnim["crossbowcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["crossbowcrouch"] = 266
NPCAnim.CitizenMaleAnim["crossbowaimcrouch"] = 275
NPCAnim.CitizenMaleAnim["crossbowaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["crossbowreload"] = 359
NPCAnim.CitizenMaleAnim["crossbowfire"] = 266
 
NPCAnim.CitizenMaleAnim["meleeidle"] = 1
NPCAnim.CitizenMaleAnim["meleewalk"] = 6
NPCAnim.CitizenMaleAnim["meleerun"] = 10
NPCAnim.CitizenMaleAnim["meleeaimidle"] = 266
NPCAnim.CitizenMaleAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["meleeaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["meleecrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["meleecrouch"] = 5
NPCAnim.CitizenMaleAnim["meleeaimwalk"] = 6
NPCAnim.CitizenMaleAnim["meleeaimrun"] = 10
NPCAnim.CitizenMaleAnim["meleefire"] = 266
 
NPCAnim.CitizenMaleAnim["rpgidle"] = 1
NPCAnim.CitizenMaleAnim["rpgwalk"] = 6
NPCAnim.CitizenMaleAnim["rpgrun"] = 10
NPCAnim.CitizenMaleAnim["rpgaimidle"] = 266
NPCAnim.CitizenMaleAnim["rpgaimwalk"] = 6
NPCAnim.CitizenMaleAnim["rpgaimrun"] = 10
NPCAnim.CitizenMaleAnim["rpgcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["rpgcrouch"] = 5
NPCAnim.CitizenMaleAnim["rpgaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["rpgaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["rpgfire"] = 266
 
NPCAnim.CitizenMaleAnim["grenadeidle"] = 1
NPCAnim.CitizenMaleAnim["grenadewalk"] = 6
NPCAnim.CitizenMaleAnim["grenaderun"] = 10
NPCAnim.CitizenMaleAnim["grenadeaimidle"] = 1
NPCAnim.CitizenMaleAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["grenadeaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["grenadecrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["grenadecrouch"] = 5
NPCAnim.CitizenMaleAnim["grenadeaimwalk"] = 6
NPCAnim.CitizenMaleAnim["grenadeaimrun"] = 10
NPCAnim.CitizenMaleAnim["grenadefire"] = 273
 
NPCAnim.CitizenMaleAnim["slamidle"] = 1
NPCAnim.CitizenMaleAnim["slamwalk"] = 6
NPCAnim.CitizenMaleAnim["slamrun"] = 10
NPCAnim.CitizenMaleAnim["slamaimidle"] = 1
NPCAnim.CitizenMaleAnim["slamaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["slamaimcrouch"] = 5
NPCAnim.CitizenMaleAnim["slamcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["slamcrouch"] = 5
NPCAnim.CitizenMaleAnim["slamaimwalk"] = 6
NPCAnim.CitizenMaleAnim["slamaimrun"] = 10
NPCAnim.CitizenMaleAnim["slamfire"] = 266
 
NPCAnim.CitizenMaleAnim["physgunidle"] = 1
NPCAnim.CitizenMaleAnim["physgunwalk"] = 6
NPCAnim.CitizenMaleAnim["physgunrun"] = 10
NPCAnim.CitizenMaleAnim["physgunaimidle"] = 266
NPCAnim.CitizenMaleAnim["physgunaimwalk"] = 6
NPCAnim.CitizenMaleAnim["physgunaimrun"] = 10
NPCAnim.CitizenMaleAnim["physgunaimcrouchwalk"] = 8
NPCAnim.CitizenMaleAnim["physgunaimcrouch"] = 266

NPCAnim.CitizenFemaleAnim = { }
NPCAnim.CitizenFemaleModels = 
{
	
              "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl",
              "models/Humans/Group03/Female_01.mdl",
              "models/Humans/Group03/Female_02.mdl",
              "models/Humans/Group03/Female_03.mdl",
              "models/Humans/Group03/Female_04.mdl",
              "models/Humans/Group03/Female_06.mdl",
              "models/Humans/Group03/Female_07.mdl",
              "models/Humans/Group03m/Female_01.mdl",
              "models/Humans/Group03m/Female_02.mdl",
              "models/Humans/Group03m/Female_03.mdl",
              "models/Humans/Group03m/Female_04.mdl",
              "models/Humans/Group03m/Female_06.mdl",
              "models/Humans/Group03m/Female_07.mdl"
}

for k, v in pairs( NPCAnim.CitizenFemaleModels ) do

	NPCAnim.CitizenFemaleModels[k] = string.lower( v );

end

NPCAnim.CitizenFemaleAnim["idle"] = 1
NPCAnim.CitizenFemaleAnim["walk"] = 6
NPCAnim.CitizenFemaleAnim["run"] = 10
NPCAnim.CitizenFemaleAnim["glide"] = 27
NPCAnim.CitizenFemaleAnim["sit"] = 0
NPCAnim.CitizenFemaleAnim["crouch"] = 5
NPCAnim.CitizenFemaleAnim["crouchwalk"] = 8

NPCAnim.CitizenFemaleAnim["pistolidle"] = 1
NPCAnim.CitizenFemaleAnim["pistolwalk"] = 6
NPCAnim.CitizenFemaleAnim["pistolrun"] = 10
NPCAnim.CitizenFemaleAnim["pistolcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["pistolcrouch"] = 5
//NPCAnim.CitizenFemaleAnim["pistolaimidle"] = 266
NPCAnim.CitizenFemaleAnim["pistolaimidle"] = 266
NPCAnim.CitizenFemaleAnim["pistolaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["pistolaimrun"] = 10
NPCAnim.CitizenFemaleAnim["pistolaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["pistolaimcrouchwalk"] = 8                     /// BLAH SHIT BLAH ///
NPCAnim.CitizenFemaleAnim["pistolreload"] = 359
//NPCAnim.CitizenFemaleAnim["pistolfire"] = 285
NPCAnim.CitizenFemaleAnim["pistolfire"] = 266

NPCAnim.CitizenFemaleAnim["smgidle"] = 1
NPCAnim.CitizenFemaleAnim["smgrun"] = 6
NPCAnim.CitizenFemaleAnim["smgwalk"] = 10
NPCAnim.CitizenFemaleAnim["smgaimidle"] = 266
NPCAnim.CitizenFemaleAnim["smgaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["smgcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["smgcrouch"] = 5
NPCAnim.CitizenFemaleAnim["smgaimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["smgaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["smgaimrun"] = 10
NPCAnim.CitizenFemaleAnim["smgreload"] = 359
NPCAnim.CitizenFemaleAnim["smgfire"] = 266

NPCAnim.CitizenFemaleAnim["ar2idle"] = 1
NPCAnim.CitizenFemaleAnim["ar2walk"] = 6
NPCAnim.CitizenFemaleAnim["ar2run"] = 10
NPCAnim.CitizenFemaleAnim["ar2aimidle"] = 266
NPCAnim.CitizenFemaleAnim["ar2aimwalk"] = 6
NPCAnim.CitizenFemaleAnim["ar2aimrun"] = 10
NPCAnim.CitizenFemaleAnim["ar2crouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["ar2crouch"] = 5
NPCAnim.CitizenFemaleAnim["ar2aimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["ar2aimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["ar2reload"] = 359
NPCAnim.CitizenFemaleAnim["ar2fire"] = 266

NPCAnim.CitizenFemaleAnim["shotgunidle"] = 1
NPCAnim.CitizenFemaleAnim["shotgunwalk"] = 6
NPCAnim.CitizenFemaleAnim["shotgunrun"] = 10
NPCAnim.CitizenFemaleAnim["shotgunaimidle"] = 266
NPCAnim.CitizenFemaleAnim["shotgunaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["shotgunaimrun"] = 10
NPCAnim.CitizenFemaleAnim["shotguncrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["shotguncrouch"] = 5
NPCAnim.CitizenFemaleAnim["shotgunaimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["shotgunaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["shotgunreload"] = 359
NPCAnim.CitizenFemaleAnim["shotgunfire"] = 266

NPCAnim.CitizenFemaleAnim["crossbowidle"] = 1
NPCAnim.CitizenFemaleAnim["crossbowwalk"] = 6
NPCAnim.CitizenFemaleAnim["crossbowrun"] = 10
NPCAnim.CitizenFemaleAnim["crossbowaimidle"] = 266
NPCAnim.CitizenFemaleAnim["crossbowaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["crossbowaimrun"] = 10
NPCAnim.CitizenFemaleAnim["crossbowcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["crossbowcrouch"] = 5
NPCAnim.CitizenFemaleAnim["crossbowaimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["crossbowaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["crossbowreload"] = 359
NPCAnim.CitizenFemaleAnim["crossbowfire"] = 266

NPCAnim.CitizenFemaleAnim["meleeidle"] = 1
NPCAnim.CitizenFemaleAnim["meleewalk"] = 6
NPCAnim.CitizenFemaleAnim["meleerun"] = 10
NPCAnim.CitizenFemaleAnim["meleeaimidle"] = 266
NPCAnim.CitizenFemaleAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["meleeaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["meleecrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["meleecrouch"] = 5
NPCAnim.CitizenFemaleAnim["meleeaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["meleeaimrun"] = 10
NPCAnim.CitizenFemaleAnim["meleefire"] = 266

NPCAnim.CitizenFemaleAnim["rpgidle"] = 1
NPCAnim.CitizenFemaleAnim["rpgwalk"] = 6
NPCAnim.CitizenFemaleAnim["rpgrun"] = 10
NPCAnim.CitizenFemaleAnim["rpgaimidle"] = 266
NPCAnim.CitizenFemaleAnim["rpgaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["rpgaimrun"] = 10
NPCAnim.CitizenFemaleAnim["rpgcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["rpgcrouch"] = 5
NPCAnim.CitizenFemaleAnim["rpgaimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["rpgaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["rpgfire"] = 266

NPCAnim.CitizenFemaleAnim["grenadeidle"] = 1
NPCAnim.CitizenFemaleAnim["grenadewalk"] = 6
NPCAnim.CitizenFemaleAnim["grenaderun"] = 10
NPCAnim.CitizenFemaleAnim["grenadeaimidle"] = 1
NPCAnim.CitizenFemaleAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["grenadeaimcrouch"] = 266
NPCAnim.CitizenFemaleAnim["grenadecrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["grenadecrouch"] = 5
NPCAnim.CitizenFemaleAnim["grenadeaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["grenadeaimrun"] = 10
NPCAnim.CitizenFemaleAnim["grenadefire"] = 266

NPCAnim.CitizenFemaleAnim["slamidle"] = 1
NPCAnim.CitizenFemaleAnim["slamwalk"] = 6
NPCAnim.CitizenFemaleAnim["slamrun"] = 10
NPCAnim.CitizenFemaleAnim["slamaimidle"] = 1
NPCAnim.CitizenFemaleAnim["slamaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["slamaimcrouch"] = 5
NPCAnim.CitizenFemaleAnim["slamcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["slamcrouch"] = 5
NPCAnim.CitizenFemaleAnim["slamaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["slamaimrun"] = 10
NPCAnim.CitizenFemaleAnim["slamfire"] = 266

NPCAnim.CitizenFemaleAnim["physgunidle"] = 1
NPCAnim.CitizenFemaleAnim["physgunwalk"] = 6
NPCAnim.CitizenFemaleAnim["physgunrun"] = 10
NPCAnim.CitizenFemaleAnim["physgunaimidle"] = 266
NPCAnim.CitizenFemaleAnim["physgunaimwalk"] = 6
NPCAnim.CitizenFemaleAnim["physgunaimrun"] = 10
NPCAnim.CitizenFemaleAnim["physgunaimcrouchwalk"] = 8
NPCAnim.CitizenFemaleAnim["physgunaimcrouch"] = 5

NPCAnim.CombineMetroAnim = { }
NPCAnim.CombineMetroModels =
{
	 "models/police.mdl",
	 "models/leet_police2.mdl"
}

for k, v in pairs( NPCAnim.CombineMetroModels ) do

	NPCAnim.CombineMetroModels[k] = string.lower( v );

end


NPCAnim.CombineMetroAnim["idle"] = 1
NPCAnim.CombineMetroAnim["walk"] = 6
NPCAnim.CombineMetroAnim["run"] = 10
NPCAnim.CombineMetroAnim["glide"] = 27
NPCAnim.CombineMetroAnim["sit"] = 0
NPCAnim.CombineMetroAnim["crouch"] = 266
NPCAnim.CombineMetroAnim["crouchwalk"] = 8

NPCAnim.CombineMetroAnim["pistolidle"] = 1
NPCAnim.CombineMetroAnim["pistolwalk"] = 6
NPCAnim.CombineMetroAnim["pistolrun"] = 10
NPCAnim.CombineMetroAnim["pistolcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["pistolcrouch"] = 266
NPCAnim.CombineMetroAnim["pistolaimidle"] = 266
NPCAnim.CombineMetroAnim["pistolaimwalk"] = 6
NPCAnim.CombineMetroAnim["pistolaimrun"] = 10
NPCAnim.CombineMetroAnim["pistolaimcrouch"] = 266
NPCAnim.CombineMetroAnim["pistolaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["pistolreload"] = 359
NPCAnim.CombineMetroAnim["pistolfire"] = 266

NPCAnim.CombineMetroAnim["smgidle"] = 1
NPCAnim.CombineMetroAnim["smgrun"] = 6
NPCAnim.CombineMetroAnim["smgwalk"] = 10
NPCAnim.CombineMetroAnim["smgaimidle"] = 266
NPCAnim.CombineMetroAnim["smgaimwalk"] = 6
NPCAnim.CombineMetroAnim["smgcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["smgcrouch"] = 266
NPCAnim.CombineMetroAnim["smgaimcrouch"] = 266
NPCAnim.CombineMetroAnim["smgaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["smgaimrun"] = 10
NPCAnim.CombineMetroAnim["smgreload"] = 359
NPCAnim.CombineMetroAnim["smgfire"] = 266

NPCAnim.CombineMetroAnim["ar2idle"] = 1
NPCAnim.CombineMetroAnim["ar2walk"] = 6
NPCAnim.CombineMetroAnim["ar2run"] = 10
NPCAnim.CombineMetroAnim["ar2aimidle"] = 266
NPCAnim.CombineMetroAnim["ar2aimwalk"] = 6
NPCAnim.CombineMetroAnim["ar2aimrun"] = 10
NPCAnim.CombineMetroAnim["ar2crouchwalk"] = 8
NPCAnim.CombineMetroAnim["ar2crouch"] = 266
NPCAnim.CombineMetroAnim["ar2aimcrouch"] = 266
NPCAnim.CombineMetroAnim["ar2aimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["ar2reload"] = 359
NPCAnim.CombineMetroAnim["ar2fire"] = 266

NPCAnim.CombineMetroAnim["shotgunidle"] = 1
NPCAnim.CombineMetroAnim["shotgunwalk"] = 10
NPCAnim.CombineMetroAnim["shotgunrun"] = 6
NPCAnim.CombineMetroAnim["shotgunaimidle"] = 266
NPCAnim.CombineMetroAnim["shotgunaimwalk"] = 6
NPCAnim.CombineMetroAnim["shotgunaimrun"] = 10
NPCAnim.CombineMetroAnim["shotguncrouchwalk"] = 8
NPCAnim.CombineMetroAnim["shotguncrouch"] = 266
NPCAnim.CombineMetroAnim["shotgunaimcrouch"] = 266
NPCAnim.CombineMetroAnim["shotgunaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["shotgunreload"] = 359
NPCAnim.CombineMetroAnim["shotgunfire"] = 266

NPCAnim.CombineMetroAnim["crossbowidle"] = 1
NPCAnim.CombineMetroAnim["crossbowwalk"] = 6
NPCAnim.CombineMetroAnim["crossbowrun"] = 10
NPCAnim.CombineMetroAnim["crossbowaimidle"] = 266
NPCAnim.CombineMetroAnim["crossbowaimwalk"] = 6
NPCAnim.CombineMetroAnim["crossbowaimrun"] = 10
NPCAnim.CombineMetroAnim["crossbowcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["crossbowcrouch"] = 266
NPCAnim.CombineMetroAnim["crossbowaimcrouch"] = 266
NPCAnim.CombineMetroAnim["crossbowaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["crossbowreload"] = 359
NPCAnim.CombineMetroAnim["crossbowfire"] = 266

NPCAnim.CombineMetroAnim["meleeidle"] = 1
NPCAnim.CombineMetroAnim["meleewalk"] = 6
NPCAnim.CombineMetroAnim["meleerun"] = 10
NPCAnim.CombineMetroAnim["meleeaimidle"] = 266
NPCAnim.CombineMetroAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["meleeaimcrouch"] = 266
NPCAnim.CombineMetroAnim["meleecrouchwalk"] = 8
NPCAnim.CombineMetroAnim["meleecrouch"] = 266
NPCAnim.CombineMetroAnim["meleeaimwalk"] = 6
NPCAnim.CombineMetroAnim["meleeaimrun"] = 10
NPCAnim.CombineMetroAnim["meleefire"] = 266

NPCAnim.CombineMetroAnim["rpgidle"] = 1
NPCAnim.CombineMetroAnim["rpgwalk"] = 6
NPCAnim.CombineMetroAnim["rpgrun"] = 10
NPCAnim.CombineMetroAnim["rpgaimidle"] = 266
NPCAnim.CombineMetroAnim["rpgaimwalk"] = 6
NPCAnim.CombineMetroAnim["rpgaimrun"] = 10
NPCAnim.CombineMetroAnim["rpgcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["rpgcrouch"] = 266
NPCAnim.CombineMetroAnim["rpgaimcrouch"] = 266
NPCAnim.CombineMetroAnim["rpgaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["rpgreload"] = 359
NPCAnim.CombineMetroAnim["rpgfire"] = 266

NPCAnim.CombineMetroAnim["grenadeidle"] = 1
NPCAnim.CombineMetroAnim["grenadewalk"] = 6
NPCAnim.CombineMetroAnim["grenaderun"] = 10
NPCAnim.CombineMetroAnim["grenadeaimidle"] = 1
NPCAnim.CombineMetroAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["grenadeaimcrouch"] = 266
NPCAnim.CombineMetroAnim["grenadecrouchwalk"] = 8
NPCAnim.CombineMetroAnim["grenadecrouch"] = 266
NPCAnim.CombineMetroAnim["grenadeaimwalk"] = 6
NPCAnim.CombineMetroAnim["grenadeaimrun"] = 10
NPCAnim.CombineMetroAnim["grenadefire"] = 273

NPCAnim.CombineMetroAnim["slamidle"] = 1
NPCAnim.CombineMetroAnim["slamwalk"] = 6
NPCAnim.CombineMetroAnim["slamrun"] = 10
NPCAnim.CombineMetroAnim["slamaimidle"] = 1
NPCAnim.CombineMetroAnim["slamaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["slamaimcrouch"] = 266
NPCAnim.CombineMetroAnim["slamcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["slamcrouch"] = 266
NPCAnim.CombineMetroAnim["slamaimwalk"] = 6
NPCAnim.CombineMetroAnim["slamaimrun"] = 10
NPCAnim.CombineMetroAnim["slamfire"] = 266

NPCAnim.CombineMetroAnim["physgunidle"] = 1
NPCAnim.CombineMetroAnim["physgunwalk"] = 6
NPCAnim.CombineMetroAnim["physgunrun"] = 10
NPCAnim.CombineMetroAnim["physgunaimidle"] = 266
NPCAnim.CombineMetroAnim["physgunaimwalk"] = 6
NPCAnim.CombineMetroAnim["physgunaimrun"] = 10
NPCAnim.CombineMetroAnim["physgunaimcrouchwalk"] = 8
NPCAnim.CombineMetroAnim["physgunaimcrouch"] = 266

NPCAnim.CombineOWAnim = { }

NPCAnim.CombineOWModels =
{
	
	"models/combine_super_soldier.mdl",
	"models/Combine_Soldier.mdl",
	"models/Combine_Black_Soldier.mdl"

}

for k, v in pairs( NPCAnim.CombineOWModels ) do

	NPCAnim.CombineOWModels[k] = string.lower( v );

end


NPCAnim.CombineOWAnim["idle"] = 1
NPCAnim.CombineOWAnim["walk"] = 6
NPCAnim.CombineOWAnim["run"] = 10
NPCAnim.CombineOWAnim["glide"] = 27
NPCAnim.CombineOWAnim["sit"] = 0
NPCAnim.CombineOWAnim["crouch"] = 5
NPCAnim.CombineOWAnim["crouchwalk"] = 8

NPCAnim.CombineOWAnim["pistolidle"] = 1
NPCAnim.CombineOWAnim["pistolwalk"] = 6
NPCAnim.CombineOWAnim["pistolrun"] = 10
NPCAnim.CombineOWAnim["pistolcrouchwalk"] = 8
NPCAnim.CombineOWAnim["pistolcrouch"] = 5
NPCAnim.CombineOWAnim["pistolaimidle"] = 266
NPCAnim.CombineOWAnim["pistolaimwalk"] = 6
NPCAnim.CombineOWAnim["pistolaimrun"] = 10
NPCAnim.CombineOWAnim["pistolaimcrouch"] = 5
NPCAnim.CombineOWAnim["pistolaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["pistolreload"] = 359
NPCAnim.CombineOWAnim["pistolfire"] = 266

NPCAnim.CombineOWAnim["smgidle"] = 1
NPCAnim.CombineOWAnim["smgrun"] = 6
NPCAnim.CombineOWAnim["smgwalk"] = 6
NPCAnim.CombineOWAnim["smgaimidle"] = 266
NPCAnim.CombineOWAnim["smgaimwalk"] = 6
NPCAnim.CombineOWAnim["smgcrouchwalk"] = 8
NPCAnim.CombineOWAnim["smgcrouch"] = 5
NPCAnim.CombineOWAnim["smgaimcrouch"] = 266
NPCAnim.CombineOWAnim["smgaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["smgaimrun"] = 10
NPCAnim.CombineOWAnim["smgreload"] = 359
NPCAnim.CombineOWAnim["smgfire"] = 266

NPCAnim.CombineOWAnim["ar2idle"] = 1
NPCAnim.CombineOWAnim["ar2walk"] = 6
NPCAnim.CombineOWAnim["ar2run"] = 10
NPCAnim.CombineOWAnim["ar2aimidle"] = 266
NPCAnim.CombineOWAnim["ar2aimwalk"] = 6
NPCAnim.CombineOWAnim["ar2aimrun"] = 10
NPCAnim.CombineOWAnim["ar2crouchwalk"] = 8
NPCAnim.CombineOWAnim["ar2crouch"] = 5
NPCAnim.CombineOWAnim["ar2aimcrouch"] = 266
NPCAnim.CombineOWAnim["ar2aimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["ar2reload"] = 359
NPCAnim.CombineOWAnim["ar2fire"] = 266

NPCAnim.CombineOWAnim["shotgunidle"] = 1
NPCAnim.CombineOWAnim["shotgunwalk"] = 6
NPCAnim.CombineOWAnim["shotgunrun"] = 10
NPCAnim.CombineOWAnim["shotgunaimidle"] = 266
NPCAnim.CombineOWAnim["shotgunaimwalk"] = 6
NPCAnim.CombineOWAnim["shotgunaimrun"] = 10
NPCAnim.CombineOWAnim["shotguncrouchwalk"] = 8
NPCAnim.CombineOWAnim["shotguncrouch"] = 5
NPCAnim.CombineOWAnim["shotgunaimcrouch"] = 266
NPCAnim.CombineOWAnim["shotgunaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["shotgunreload"] = 359
NPCAnim.CombineOWAnim["shotgunfire"] = 266

NPCAnim.CombineOWAnim["crossbowidle"] = 1
NPCAnim.CombineOWAnim["crossbowwalk"] = 6
NPCAnim.CombineOWAnim["crossbowrun"] = 10
NPCAnim.CombineOWAnim["crossbowaimidle"] = 266
NPCAnim.CombineOWAnim["crossbowaimwalk"] = 6
NPCAnim.CombineOWAnim["crossbowaimrun"] = 10
NPCAnim.CombineOWAnim["crossbowcrouchwalk"] = 8
NPCAnim.CombineOWAnim["crossbowcrouch"] = 5
NPCAnim.CombineOWAnim["crossbowaimcrouch"] = 266
NPCAnim.CombineOWAnim["crossbowaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["crossbowreload"] = 359
NPCAnim.CombineOWAnim["crossbowfire"] = 266

NPCAnim.CombineOWAnim["meleeidle"] = 1
NPCAnim.CombineOWAnim["meleewalk"] = 6
NPCAnim.CombineOWAnim["meleerun"] = 10
NPCAnim.CombineOWAnim["meleeaimidle"] = 266
NPCAnim.CombineOWAnim["meleeaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["meleeaimcrouch"] = 5
NPCAnim.CombineOWAnim["meleecrouchwalk"] = 8
NPCAnim.CombineOWAnim["meleecrouch"] = 5
NPCAnim.CombineOWAnim["meleeaimwalk"] = 6
NPCAnim.CombineOWAnim["meleeaimrun"] = 10
NPCAnim.CombineOWAnim["meleefire"] = 266

NPCAnim.CombineOWAnim["rpgidle"] = 1
NPCAnim.CombineOWAnim["rpgwalk"] = 6
NPCAnim.CombineOWAnim["rpgrun"] = 10
NPCAnim.CombineOWAnim["rpgaimidle"] = 266
NPCAnim.CombineOWAnim["rpgaimwalk"] = 6
NPCAnim.CombineOWAnim["rpgaimrun"] = 10
NPCAnim.CombineOWAnim["rpgcrouchwalk"] = 8
NPCAnim.CombineOWAnim["rpgcrouch"] = 5
NPCAnim.CombineOWAnim["rpgaimcrouch"] = 266
NPCAnim.CombineOWAnim["rpgaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["rpgreload"] = 359
NPCAnim.CombineOWAnim["rpgfire"] = 266

NPCAnim.CombineOWAnim["grenadeidle"] = 1
NPCAnim.CombineOWAnim["grenadewalk"] = 6
NPCAnim.CombineOWAnim["grenaderun"] = 10
NPCAnim.CombineOWAnim["grenadeaimidle"] = 1
NPCAnim.CombineOWAnim["grenadeaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["grenadeaimcrouch"] = 5
NPCAnim.CombineOWAnim["grenadecrouchwalk"] = 8
NPCAnim.CombineOWAnim["grenadecrouch"] = 5
NPCAnim.CombineOWAnim["grenadeaimwalk"] = 6
NPCAnim.CombineOWAnim["grenadeaimrun"] = 10
NPCAnim.CombineOWAnim["grenadefire"] = 266

NPCAnim.CombineOWAnim["slamidle"] = 1
NPCAnim.CombineOWAnim["slamwalk"] = 6
NPCAnim.CombineOWAnim["slamrun"] = 10
NPCAnim.CombineOWAnim["slamaimidle"] = 1
NPCAnim.CombineOWAnim["slamaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["slamaimcrouch"] = 5
NPCAnim.CombineOWAnim["slamcrouchwalk"] = 8
NPCAnim.CombineOWAnim["slamcrouch"] = 5
NPCAnim.CombineOWAnim["slamaimwalk"] = 6
NPCAnim.CombineOWAnim["slamaimrun"] = 10
NPCAnim.CombineOWAnim["slamfire"] = 266

NPCAnim.CombineOWAnim["physgunidle"] = 1
NPCAnim.CombineOWAnim["physgunwalk"] = 6
NPCAnim.CombineOWAnim["physgunrun"] = 10
NPCAnim.CombineOWAnim["physgunaimidle"] = 1
NPCAnim.CombineOWAnim["physgunaimwalk"] = 6
NPCAnim.CombineOWAnim["physgunaimrun"] = 10
NPCAnim.CombineOWAnim["physgunaimcrouchwalk"] = 8
NPCAnim.CombineOWAnim["physgunaimcrouch"] = 5

WeapActivityTranslate = { }

WeapActivityTranslate[ACT_HL2MP_IDLE_PISTOL] = "pistol";
WeapActivityTranslate[ACT_HL2MP_IDLE_SMG1] = "smg";
WeapActivityTranslate[ACT_HL2MP_IDLE_AR2] = "ar2";
WeapActivityTranslate[ACT_HL2MP_IDLE_RPG] = "rpg";
WeapActivityTranslate[ACT_HL2MP_IDLE_GRENADE] = "grenade";
WeapActivityTranslate[ACT_HL2MP_IDLE_SHOTGUN] = "shotgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_PHYSGUN] = "physgun";
WeapActivityTranslate[ACT_HL2MP_IDLE_CROSSBOW] = "crossbow";
WeapActivityTranslate[ACT_HL2MP_IDLE_SLAM] = "slam";
WeapActivityTranslate[ACT_HL2MP_IDLE_MELEE] = "melee";
WeapActivityTranslate[ACT_HL2MP_IDLE] = "";
WeapActivityTranslate["weapon_pistol"] = "pistol";
WeapActivityTranslate["weapon_357"] = "pistol";
WeapActivityTranslate["gmod_tool"] = "pistol";
WeapActivityTranslate["weapon_smg1"] = "smg";
WeapActivityTranslate["weapon_ar2"] = "ar2";
WeapActivityTranslate["weapon_rpg"] = "rpg";
WeapActivityTranslate["weapon_frag"] = "grenade";
WeapActivityTranslate["weapon_slam"] = "slam";
WeapActivityTranslate["weapon_physgun"] = "physgun";
WeapActivityTranslate["weapon_physcannon"] = "physgun";
WeapActivityTranslate["weapon_crossbow"] = "crossbow";
WeapActivityTranslate["weapon_shotgun"] = "shotgun";
WeapActivityTranslate["weapon_crowbar"] = "melee";
WeapActivityTranslate["weapon_stunstick"] = "melee";

function GetWeaponAct( ply, act )
	

	local weap = ply:GetActiveWeapon();
	local class = weap:GetClass();
	
	local trans = "";
	local posttrans = "";
	
	if( weap:GetNWBool( "NPCAimed" ) ) then
		posttrans = "aim";	
	else
		
		if( weap:GetTable().NotHolsterAnim ) then
		
			act = weap:GetTable().NotHolsterAnim;
		
		end
	
	end

	if( act ~= -1 ) then
		trans = WeapActivityTranslate[act];
	else
		trans = WeapActivityTranslate[class];
	end
	
	return trans .. ( posttrans or "" );

end


function GM:SetPlayerAnimation( ply, weapanim )

	if( !NPC_ANIMS_ENABLED ) then return; end
	
	if( !ply:IsValid() or !ply:Alive() or ply:GetNWInt( "isko" ) == 1 ) then
		return;
	end	
		
	if( LAG_TEST ) then
		
		Msg( "NPCAnim.SetPlayerAnimation : " .. ply:Nick() .. "\n" );
		
	end
	
	local seq = 0;
	
	if( !ply:GetField( "OverrideAnim" ) ) then
	
		--ply:SetField( "ChangeAnim", false );
	
		local weap = ply:GetActiveWeapon();
		local animname = ply:GetField( "WeapAnim" );
		
		local seqname = "";
		
		local speed = ply:GetVelocity():Length();
		
		if( speed >= 120 ) then
		
			if( ply:OnGround() && ply:Crouching() ) then
				seqname = animname .. "crouchrun";
			else
				seqname = animname .. "run";
			end
		
		elseif( speed >= 10 ) then
		
			if( ply:OnGround() && ply:Crouching() ) then
				seqname = animname .. "crouchwalk";
			else
				seqname = animname .. "walk";
			end
		
		else
			
			if( ply:OnGround() && ply:Crouching() ) then
				seqname = animname .. "crouch";
			else
				seqname = animname .. "idle";
			end
			
		end
	
		local AnimTable = ply:GetTable().AnimTable;
		
		if( !AnimTable ) then
		
			local model = string.lower( ply:GetModel() );
	
			ply:GetTable().AnimTable = NPCAnim.CitizenMaleAnim;
			
			if( table.HasValue( NPCAnim.CitizenFemaleModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CitizenFemaleAnim; end
			if( table.HasValue( NPCAnim.CombineMetroModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineMetroAnim; end
			if( table.HasValue( NPCAnim.CombineOWModels, model ) ) then ply:GetTable().AnimTable = NPCAnim.CombineOWAnim; end
			
			AnimTable = ply:GetTable().AnimTable;
		
		end
		
		if( ( weapanim == PLAYER_ATTACK1 or weapanim == PLAYER_RELOAD ) && weap:IsValid() ) then
	
			local act = nil;
		
			if( weapanim == PLAYER_RELOAD ) then
	
				local actname = string.gsub( seqname, "aim", "" ) .. "reload";
				actname = string.gsub( actname, "idle", "" );
			
				local act = tonumber( AnimTable[actname] );
				
				if( act == nil ) then
					return;
				end
	
				ply:RestartGesture( act );
			
				return true;
				
			else
			
				if( string.find( seqname, "melee" ) or string.find( seqname, "grenade" ) or string.find( seqname, "slam" ) ) then
				
					local actname = string.gsub( seqname, "aim", "" ) .. "fire";
					actname = string.gsub( actname, "idle", "" );
				
					local act = tonumber( AnimTable[actname] );
					
					if( act == nil ) then
						return;
					end
	
					ply:RestartGesture( act );
					ply:Weapon_SetActivity( act, 0 );
					
					return true;
					
				end
			
				return;
				
			end
		
		end
	
		if ( ( !ply:OnGround() or ply:WaterLevel() > 4 ) && 
			   !ply:InVehicle() ) then
			seqname = "glide";
		end
	 
	
		local actid = AnimTable[seqname];
	
		if( actid == nil or actid == -1 ) then
			seq = ply:GetSequence();
		else
			seq = ply:SelectWeightedSequence( actid );
		end
		
		--ply:SetField( "CrntActID", seq );
		
	else
	
		seq = ply:GetField( "CrntActID" );
	
	end


	if ( ply:GetSequence() == seq ) then return true; end

	ply:SetPlaybackRate( 1 );
	ply:ResetSequence( seq );
	ply:SetCycle( 1 );
	
	return true;

end
