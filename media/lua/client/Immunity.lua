require "Communications/QSystem"
require "Scripting/CharacterManager"

Immunity = {};
local active = false;

function Immunity.onGameStart()
    TraitFactory.addTrait("immunity", "???", 0, "???", false);
end

function Immunity.onQSystemUpdate(code)
    if code == 0 or code == 4 then
        local player = getPlayer();
        if player then
            if CharacterManager.instance then
                if CharacterManager.instance:isFlag("immunity_route") then
                    if not active then
                        player:getTraits():add("immunity");
                        active = true;
                    end
                else
                    if active then
                        player:getTraits():remove("immunity");
                        active = false;
                    end
                end
            end
        end
    end
end

function Immunity.restore()
    local player = getPlayer();
    if player then
        if active then
            local bodyDamage = player:getBodyDamage();
            if bodyDamage:isInfected() then
                local bodyParts = bodyDamage:getBodyParts();
                for i=0, bodyParts:size()-1 do
                    bodyParts:get(i):SetInfected(false);
                end
                bodyDamage:setInfected(false);
                bodyDamage:setInfectionLevel(0.0);
                bodyDamage:setInfectionTime(-1.0);
                --print("Infection cured");
            end
        end
    end
end

function Immunity.onCreatePlayer()
	active = false;
    Immunity.onQSystemUpdate(4);
end

Events.OnGameStart.Add(Immunity.onGameStart);
Events.OnCreatePlayer.Add(Immunity.onCreatePlayer);
Events.OnQSystemUpdate.Add(Immunity.onQSystemUpdate);
Events.EveryOneMinute.Add(Immunity.restore);
