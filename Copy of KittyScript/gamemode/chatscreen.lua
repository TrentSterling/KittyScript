lol
surface.CreateFont( "ChatFont", 14, 800, true, false, "NewChatFont" );

ChosenChatLevel = 1;
ChatBoxDelay = 0;

function ShiftChatBoxUp( ChatBox, offset )

	local first = true;

	for k, v in pairs( ChatBox.ChatLines ) do

		local x, y = v:GetPos();

		y = y - offset;
		
		v.origy = y;
		v.shadow.origy = y;
		v.y = y;
		
		v:SetPos( x, y );
		v.shadow:SetPos( x + 1, y + 1 );
	
		x, y = v.topic:GetPos();
		
		y = y - offset;
	
		v.topic.origy = y;
		v.topicshadow.origy = y;
		v.topic.y = y;
		
		v.topic:SetPos( x, y );
		v.topicshadow:SetPos( x + 1, y + 1 );
		
		if( first ) then
		

			first = false;
		
		end
	
	end

end

function msgAddPrintMessage( msg )

	if( not ChatVGUI ) then return; end

	local topic = "";
	local text = msg:ReadString();
	local vec = msg:ReadVector();
	local color = Color( vec.x, vec.y, vec.z );
	local topiccolor = color;
	local level = msg:ReadShort();

	AddToChatBox( topic, text, topiccolor, color, level );
	
	if( level ~= 1 ) then
		AddToChatBox( topic, text, topiccolor, color, 1 );
	end
	
	if( level ~= ChosenChatLevel ) then
	
		ChatVGUI.OptBut[level].ShouldFlash = true;
	
	end

end
usermessage.Hook( "AddPrintMessage", msgAddPrintMessage );

function msgAddChatLine( msg ) 

	if( not ChatVGUI ) then return; end

	local topic = msg:ReadString();
	local text = msg:ReadString();
	local vec = msg:ReadVector();
	local topiccolor = Color( vec.x, vec.y, vec.z );
	vec = msg:ReadVector();
	local color = Color( vec.x, vec.y, vec.z );
	local level = msg:ReadShort();

	AddToChatBox( topic, text, topiccolor, color, level );
	
	if( level ~= 1 ) then
	
		AddToChatBox( topic, text, topiccolor, color, 1 );
	
	end
	
	if( level ~= ChosenChatLevel ) then
	
		ChatVGUI.OptBut[level].ShouldFlash = true;
	
	end

end
usermessage.Hook( "AddToChatBox", msgAddChatLine );

function AddToChatBox( topic, text, topiccolor, color, level )
	
	local function Add( topic, text, topiccolor, color, level )
	
		local Body = ChatVGUI.HiddenAllTextBody;
		
		if( level == 2 ) then
			Body = ChatVGUI.HiddenICTextBody;
		end
		
		if( level == 3 ) then
			Body = ChatVGUI.HiddenPMTextBody;
		end
	
		

		local text, endlines = FormatLine( text, "NewChatFont", Body:GetWide() - 65, true );
		local newline = Body:AddLabel( text, "NewChatFont", 2, 137 - ( endlines * 15 ), color );
		newline.shadow = Body:AddLabel( text, "NewChatFont", 3, 138 - ( endlines * 15 ), Color( 0, 0, 0, 255 ) );
		newline.topic = Body:AddLabel( topic, "NewChatFont", 2, 137 - ( endlines * 15 ), topiccolor );
		newline.topicshadow = Body:AddLabel( topic, "NewChatFont", 3, 138 - ( endlines * 15 ), Color( 0, 0, 0, 255 ) );
		
		surface.SetFont( "NewChatFont" );
		
		local spacelen = surface.GetTextSize( " " );
		local topiclen = surface.GetTextSize( topic );
		
		local spacenum = math.ceil( topiclen / spacelen );
		
		local x, y = newline:GetPos();
		--newline:SetPos( x + surface.GetTextSize( topic ), y );
		newline:SetText( string.rep( " ", spacenum ) .. string.sub( text, string.len( topic ) + 1 ) );
		--newline.shadow:SetPos( x + surface.GetTextSize( topic ) + 1, y + 1 );
		newline.shadow:SetText( string.rep( " ", spacenum ) .. string.sub( text, string.len( topic ) + 1 ) );
		
		newline:SetSize( Body:GetWide(), newline:GetTall() );
		newline.shadow:SetSize( Body:GetWide(), newline:GetTall() );
		
		newline.shadow:SetZPos( 1 );
		newline:SetZPos( 2 );
		newline.topic:SetZPos( 2 );
		newline.topicshadow:SetZPos( 1 );
		newline.alive = true;
		
		newline.start = CurTime();
		
		ShiftChatBoxUp( Body, ( endlines + 1 ) * 15 );
		
		table.insert( Body.ChatLines, newline );
			
		ChatBoxDelay = ChatBoxDelay - .1;

		
	end
	timer.Simple( ChatBoxDelay, Add, topic, text, topiccolor, color, level );

	ChatBoxDelay = ChatBoxDelay + .1;

end

function ChatBoxThink()

	if( ChatVGUI and ChatVGUI:IsVisible() ) then
	
		for n = 1, 3 do
		
			if( ChatVGUI.OptBut[n].ShouldFlash ) then
			
				if( CurTime() - ChatVGUI.OptBut[n].LastFlash > .4 ) then
				
					local color = Color( 60, 60, 60, 200 );
					
					if( not ChatVGUI.OptBut[n].IsFlashed ) then
					
						color = Color( 30, 30, 190, 200 );
						ChatVGUI.OptBut[n].IsFlashed = true;
					
					else
					
						ChatVGUI.OptBut[n].IsFlashed = false;
					
					end
					
					ChatVGUI.OptBut[n]:SetColor( color );
					
					ChatVGUI.OptBut[n].LastFlash = CurTime();
				
				end
			
			end
	
		end
	
	end
	
	if( ChatVGUI ) then
	
		local Body = ChatVGUI.HiddenAllTextBody;
		
		if( ChosenChatLevel == 2 ) then
			Body = ChatVGUI.HiddenICTextBody;
		end
		
		if( ChosenChatLevel == 3 ) then
			Body = ChatVGUI.HiddenPMTextBody;
		end
	
		for k, v in pairs( Body.ChatLines ) do
	
			local r = v.r;
			local g = v.g;
			local b = v.b;
			local a = v.a;
			
			if( v.alive and CurTime() - v.start > 10 ) then
			
				a = math.Clamp( a - 200 * FrameTime(), 0, 255 );
				
				if( a <= 0 ) then
				
					Body.ChatLines[k].alive = false;	
				
				end
				
			end
			
			v.a = a;
			v.topic.a = a;
			v.topicshadow.a = a;
			v.shadow.a = a;
			
			if( ChatVGUI:IsVisible() ) then
			
				v.topic:SetFGColor( v.topic.r, v.topic.g, v.topic.b, 255 );
				v.topicshadow:SetFGColor( 0, 0, 0, 255 );
				v:SetFGColor( r, g, b, 255 );
				v.shadow:SetFGColor( 0, 0, 0, 255 );
			
			else
			
				v.topic:SetFGColor( v.topic.r, v.topic.g, v.topic.b, v.topic.a );
				v.topicshadow:SetFGColor( 0, 0, 0, v.topic.a );
				v:SetFGColor( r, g, b, a );
				v.shadow:SetFGColor( 0, 0, 0, a );
			
			end
		
			local _, y = v:GetPos();
			
			if( y + v:GetTall() < 0 ) then
			
				Body.ChatLines[k] = nil;
			
			end
			
		end
		
	end

end
hook.Add( "Think", "ChatBoxThink", ChatBoxThink );

--[[

function DrawChatBoxLines()

	if( ChatVGUI:IsVisible() ) then return; end

	for k, v in pairs( ChatBoxLines ) do
	
		local r = v.color.r;
		local g = v.color.a;
		local b = v.color.a;
		local a = v.a;

		draw.DrawText( v.text, "NewChatFont", 6, v.vguiy + 1, Color( 0, 0, 0, a ) );
		draw.DrawText( v.text, "NewChatFont", 5, v.vguiy, Color( r, g, b, a ) );
		
	end

end

function DrawChatBoxLinesVGUI()

	for k, v in pairs( ChatBoxLines ) do
	
		local r = v.color.r;
		local g = v.color.a;
		local b = v.color.a;
		local a = 255;

		draw.DrawText( v.text, "NewChatFont", 6, v.vguiy + 1, Color( 0, 0, 0, a ) );
		draw.DrawText( v.text, "NewChatFont", 5, v.vguiy, Color( r, g, b, a ) );
		
	end

end

]]--