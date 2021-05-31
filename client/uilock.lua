class 'UIlock' -- a recreation of JasonMRC's ProblemSolvers' ui lock

function UIlock:__init()

	self.key = 191 -- the forward slash
	
	self.active = false	-- disabled by default

	Events:Subscribe( "KeyUp", self, self.KeyUp )
	Events:Subscribe( "LocalPlayerInput", self, self.LocalPlayerInput )

	Events:Subscribe("ModulesLoad", self, self.ModulesLoad)
	Events:Subscribe("ModuleUnload", self, self.ModuleUnload)
end

function UIlock:Render() -- render the UI lock alert message
	if self.active then
	local font_scale	= math.round(Render.Size.y/1080,1) -- calc scaling factor
	local text1 = "UI lock enabled"
	local text2 = "Hit \"/\" key to disable"
	local pos1 = Vector2( Render.Width/2, Render.Height * 0.75 )
	local pos2 = Vector2( Render.Width/2, Render.Height * 0.78 )
	local font1 = TextSize.Large*font_scale
	local font2 = TextSize.Default*font_scale	
	pos1.y = pos1.y - Render:GetTextHeight(text1, font1)
	pos1.x = pos1.x - Render:GetTextWidth(text1, font1) / 2		
	pos2.y = pos2.y - Render:GetTextHeight(text2, font2)
	pos2.x = pos2.x - Render:GetTextWidth(text2, font2) / 2
	Render:DrawText( pos1 + Vector2(1,1)*font_scale, text1, Color.Black, font1)
	Render:DrawText( pos1, text1, Color.Red, font1)
	Render:DrawText( pos2 + Vector2(1,1)*font_scale, text2, Color.Black, font2)	
	Render:DrawText( pos2, text2, Color.Red, font2)	
	end
end

function UIlock:InputPoll()	-- force player into crouched state
	if self.active then Input:SetValue(Action.Crouch, 1 , false)	end
end

function UIlock:LocalPlayerInput(args)	-- block all of them actions known to humanity
	if self.active == true then
		return false
	end
end

function UIlock:KeyUp(args)
	if args.key == self.key then
		if self.active then
			Events:Unsubscribe(self.render)
			Events:Unsubscribe(self.inputpoll)
			self.active = false
			Mouse:SetVisible(false)
		else
			self.active = true
			self.inputpoll = Events:Subscribe("InputPoll", self, self.InputPoll )
			self.render = Events:Subscribe("Render", self, self.Render )
			Mouse:SetVisible(true)
		end
	end
end

function UIlock:ModulesLoad()
    Events:Fire("HelpAddItem",
        {
            name = "UI lock",
            text = 
            	"UI lock 2: Electric Boogaloo"..
                "\n\n"..
                "Press / to toggle" ..
                "\n\n"..
                "UI Lock (2020) is Urik's remake of critically acclaimed UI Lock (2014) by JasonMRC"
        })
end

function UIlock:ModuleUnload()
    Events:Fire( "HelpRemoveItem",
        {
            name = "UI lock"
        } )
end

math.round = function(x, n) -- rounding function
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

UIlock = UIlock()