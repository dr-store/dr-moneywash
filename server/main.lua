ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('dr-moneywash:laundry')
AddEventHandler('dr-moneywash:laundry', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local black = xPlayer.getAccount('black_money').money

    if black >= amount then
        local tax = amount * Config.MoneyLaundry.CleanLoss
        local cleanedMoney = amount - tax
        xPlayer.removeAccountMoney('black_money', amount)
        xPlayer.addAccountMoney('money', cleanedMoney)
        TriggerClientEvent("dr-moneywash:laundryResult", _source, cleanedMoney)
    else
        TriggerClientEvent("dr-moneywash:checkResult", _source, false, 0)
    end
end)

RegisterServerEvent('dr-moneywash:checkblack')
AddEventHandler('dr-moneywash:checkblack', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local black = xPlayer.getAccount('black_money').money
    if black >= amount then
        TriggerClientEvent('dr-moneywash:checkResult', _source, true, amount)
    else
        TriggerClientEvent('dr-moneywash:checkResult', _source, false, 0)
    end
end)