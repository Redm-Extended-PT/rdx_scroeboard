RDX = nil

Citizen.CreateThread(function() 
    Citizen.Wait(1000)
    while RDX == nil do
		TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
		Citizen.Wait(0)
    end

    RDX.RegisterServerCallback('rdx_scoreboard:server:getdata', function(source, cb)
        local xPlayer = RDX.GetPlayerFromId(source)
        local iden = xPlayer.identifier
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @iden LIMIT 0,1', {
            ['@iden'] = iden
        }, function(result)
            if not (result[1] == nil) then
                local data = {}
                local job_label = GetJobLabel(result[1].job, result[1].job_grade)
                local xPlayers = RDX.GetPlayers()
                local players = 0
                local police = 0
                local ems = 0
                local mc = 0
                for i=1, #xPlayers, 1 do
                    players = (players + 1)
                    local xP = RDX.GetPlayerFromId(xPlayers[i])
                    local xP_Job = xP.getJob()
                    if xP_Job.name == "police" then
                        police = (police + 1)
                    elseif xP_Job.name == "ambulance" then
                        ems = (ems + 1)
                    elseif xP_Job.name == "mechanic" then
                        mc = (mc + 1)
                    end
                end
                
                table.insert(data, {
                    my_phonenmumber = result[1].phone_number,
                    my_fullname = result[1].firstname .. " " .. result[1].lastname,
                    my_job = job_label,
                    my_ping = GetPlayerPing(source),
                    players = players,
                    police = police,
                    ems = ems,
                    mc = mc
                })

                cb(data)
            else
                cb(nil)
            end
        end)
    end)

end)

function GetJobLabel(job_name, job_grade)
    local result = MySQL.Sync.fetchAll('SELECT label FROM job_grades WHERE job_name = @job_name AND grade = @job_grade', {
        ['@job_name'] = job_name,
        ['@job_grade'] = job_grade
    })
    if not (result[1] == nil) then
        return result[1].label
    end
    return nil
end
