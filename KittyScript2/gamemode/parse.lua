function NewLineFix( str )
	str = string.gsub( str, "\r", "\n" );
	str = string.gsub( str, "\n\n", "\n" );
	return str;
end

function MergeArgs( tbl, arg )
	arg = arg or 1;	
	local newtbl = { }
	local num = 1;
	for n = arg, #tbl do
		if( tbl[n] ) then
			newtbl[num] = tbl[n];
			num = num + 1;
		else
			break;
		end
	end
	return newtbl;
end

--Use this function to "parse" data files
--It'll a return a big table of each line of a data file, broken up into seperate arguments

--Example:
--"Hi this is line 1
--And this is line 2"
--will turn into this:
--[ [hi] [this] [is] [line] [1] ]
--[ [And] [this] [is] [line] [2] ]
--The [] represents a table cell
function GetArgumentLists( str, includecomments )
	str = NewLineFix( str );
	if( not includecomments ) then
	--	str = RemoveComments( str );
	end
	local lines = string.Explode( "\n", str );
	local list = { }
	for k, v in pairs( lines ) do
		local listline = string.Explode( " ", v );
		listline = FormatStringTable( listline );
		local newlistline = { }
		for n, m in pairs( listline ) do
			local add = true;
			if( not includecomments ) then
				if( string.find( m, "//" ) ) then
					add = false;
					break;
				end
			end
			if( add ) then
				local newm = string.gsub( string.gsub( m, "\r", "" ), "\n", "" );
				table.insert( newlistline, newm );
			end
		end
		if( #newlistline > 0 ) then
			table.insert( list, newlistline );
		end
	end
	return list;
end

function RemoveComments( str )
	str = NewLineFix( str );
	local newstr = "";
	local pos = string.find( str, "//" );
	if( not pos ) then newstr = str; end
	while( pos ) do
		newstr = newstr .. string.sub( str, 1, pos - 1 )
		local endline = string.find( str, "\n", pos );
		if( endline ) then
			newstr = newstr .. string.sub( str, endline );
		end
		pos = string.find( str, "//", pos + 2 );
	end
	return newstr;
end

function FormatStringTable( strtable )
	local qs = false;
	local newtable = { }
	local n = 1;
	for k, v in pairs( strtable ) do
		if( string.find( v, "\"" ) ) then
			local posf = string.find( v, "\"" );
			local posl = string.find( v, "\"", posf + 1 );
			if( not qs ) then
				newtable[n] = string.sub( v, posf + 1 );
				qs = true;
				if( posl ) then
					newtable[n] = string.sub( v, posf + 1, posl - 1 );
					n = n + 1;
					qs = false;
				end
			else
				newtable[n] = newtable[n] .. " " .. string.sub( v, 1, posf - 1 );
				qs = false;
				n = n + 1;
			end
		elseif( not qs ) then
			newtable[n] = v;
			n = n + 1;
		else
			newtable[n] = newtable[n] .. " " .. v;
		end
	end
	return newtable;
end
