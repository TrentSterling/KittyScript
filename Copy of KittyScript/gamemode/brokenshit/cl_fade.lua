
FadingObj = { }

function AddFadingRect( x, y, w, h, round, color, stay, speed, forever )

	local newrect = { }
	
	newrect.x = x;
	newrect.y = y;
	newrect.w = w;
	newrect.h = h;
	newrect.round = round;
	newrect.color = color;
	newrect.delay = stay;
	newrect.fade = color.a;
	newrect.color.a = 0;
	newrect.speed = speed or 100;
	newrect.start = CurTime();
	newrect.forever = forever;

	table.insert( FadingObj, newrect );
	
	return #FadingObj;

end

function msgAddFadingRect( msg )

	AddFadingRect( msg:ReadFloat() * ScrW(), msg:ReadFloat() * ScrH(), msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), 
				   Color( msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), msg:ReadShort() ),
				   msg:ReadShort(), msg:ReadShort() );

end
usermessage.Hook( "FadingRect", msgAddFadingRect );

FadingText = { }

function AddFadingText( x, y, font, text, align, color, stay, speed, forever, xo, yo )

	local newtext = { }
	
	newtext.x = x + ( xo or 0 );
	newtext.y = y + ( yo or 0 );
	newtext.font = font;
	newtext.text = text;
	newtext.align = align;
	newtext.color = color;
	newtext.delay = stay;
	newtext.fade = color.a;
	newtext.color.a = 0;
	newtext.speed = speed or 100;
	newtext.start = CurTime();
	newtext.forever = forever;

	table.insert( FadingObj, newtext );
	
	return #FadingObj;

end

function msgAddFadingText( msg )

	AddFadingText( msg:ReadFloat() * ScrW(), msg:ReadFloat() * ScrH(), msg:ReadString(), msg:ReadString(), 
				   msg:ReadShort(), Color( msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), msg:ReadShort() ),
				   msg:ReadShort(), msg:ReadShort(), msg:ReadBool(), msg:ReadShort(), msg:ReadShort() );

end
usermessage.Hook( "FadingText", msgAddFadingText );

function HandleFade( fade )

	local dir = 1;
	local maxfade = 255;
	
	if( fade.fade ) then
		
		maxfade = fade.fade;
		
	end

	if( CurTime() > fade.start + fade.delay ) then
	
		if( fade.delay == -1 ) then return fade; end
		if( fade.color.a <= 0 ) then
			if( not fade.forever ) then
			 	return nil; 
			else
				return fade;
			end
		end
		
		dir = -1;
	
	end
	
	fade.color.a = math.Clamp( fade.color.a + fade.speed * dir * FrameTime(), 0, maxfade );

	return fade;

end

function FadeThink()

	for k, v in pairs( FadingObj ) do
		
		if( v.text ) then

			draw.DrawText( v.text, v.font, v.x, v.y, v.color, v.align );
		
		else
	
			draw.RoundedBox( v.round, v.x, v.y, v.w, v.h, v.color );
		
		end
		
		FadingObj[k] = HandleFade( v );

	end

end


