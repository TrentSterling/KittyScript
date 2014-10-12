/*//////////////////////////////////////////////
//////	Jinto gets full credit for this code 	/////
/////////////////////////////////////////////*/



  
 // client
 if( CLIENT ) then
  
     local function CalcView( pl, origin, angles, fov )
   
         // get their ragdoll
       local ragdoll = pl:GetRagdollEntity();
       if( !ragdoll || ragdoll == NULL || !ragdoll:IsValid() ) then return; end
       
        // find the eyes
        local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
        
         // setup our view
         local view = {
             origin = eyes.Pos,
             angles = eyes.Ang,
			 fov = 90, 
         };
        
          //
         return view;
     
      end
      hook.Add( "CalcView", "DeathView", CalcView );
      
       //
    
  end 
