
ItemData = { }
FactoryItems = { }

function ParseItems()

	local list = file.FindInLua( "KittyScript/gamemode/items/*.lua" );
	
	for _, v in pairs( list ) do
		
		ITEM = nil;
		ITEM = { }
		
		include( "items/" .. v );
		
		ITEM.UniqueID = string.gsub( v, ".lua", "" );
			
		ITEM.Name = ITEM.Name or "";
		ITEM.Size = ITEM.Size or 1;
		ITEM.Usable = ITEM.Usable or false;
		ITEM.Weight = ITEM.Weight or 1;
		ITEM.Model = ITEM.Model or "";
		ITEM.Desc = ITEM.Desc or "";
		
		if( ITEM.BlackMarket == nil ) then
			ITEM.BlackMarket = false;
		end
		
		if( ITEM.FactoryBuyable == nil ) then
			ITEM.FactoryBuyable = false;
		end
		
		ITEM.FactoryPrice = ITEM.FactoryPrice or 0;
		ITEM.FactoryStock = ITEM.FactoryStock or 0;
		
		ItemData[ITEM.UniqueID] = ITEM;
		
		if( ITEM.FactoryBuyable ) then
		
			local factoryitem = { }
			factoryitem.ID = ITEM.UniqueID;
			factoryitem.Name = ITEM.Name;
			factoryitem.Desc = ITEM.Desc;
			factoryitem.Model = ITEM.Model;
			factoryitem.StockPrice = ITEM.FactoryPrice;
			factoryitem.StockCount = ITEM.FactoryStock;
			factoryitem.BlackMarket = ITEM.BlackMarket;
			
			table.insert( FactoryItems, factoryitem );
			
		end
		
	end


end
