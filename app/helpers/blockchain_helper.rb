module BlockchainHelper
  require "httparty"
  require "json"

  POLYGON_RPC_URL = "https://polygon-rpc.com/"
  SWAP_EVENT_HASH = "0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822"
  MANA_CONTRACT_ADDRESS = "0xA1c57f48F0Deb89f569dFbE6E2B7f46D33606fD4"
  ERC20_ABI = {
    "name" => "0x06fdde03",
    "symbol" => "0x95d89b41",
    "decimals" => "0x313ce567",
    "totalSupply" => "0x18160ddd",
  }

  def rpc_call(method, params = [])
    response = HTTParty.post(POLYGON_RPC_URL, body: {
                                                jsonrpc: "2.0",
                                                method: "eth_call",
                                                params: [{
                                                  to: MANA_CONTRACT_ADDRESS,
                                                  data: ERC20_ABI[method],
                                                }, "latest"],
                                                id: 1,
                                              }.to_json, headers: { "Content-Type" => "application/json" })

    JSON.parse(response.body)["result"]
  rescue => e
    Rails.logger.error "Error making RPC call: #{e.message}"
    nil
  end

  def get_mana_info
    name = rpc_call("name")
    symbol = rpc_call("symbol")
    decimals = rpc_call("decimals")
    total_supply = rpc_call("totalSupply")

    {
      name: hex_to_string(name),
      symbol: hex_to_string(symbol),
      decimals: hex_to_int(decimals),
      total_supply: format_total_supply(hex_to_int(total_supply), hex_to_int(decimals)),
    }
  rescue => e
    Rails.logger.error "Error fetching MANA info: #{e.message}"
    {}
  end

  def hex_to_string(hex)
    [hex[2..-1]].pack("H*").force_encoding("UTF-8")
  end

  def hex_to_int(hex)
    hex.to_i(16)
  end

  def format_total_supply(total_supply, decimals)
    total_supply.to_f / (10 ** decimals)
  end

  def get_swap_events(block_number)
    payload = {
      jsonrpc: "2.0",
      method: "eth_getLogs",
      params: [{
        fromBlock: "0x#{block_number.to_s(16)}",
        toBlock: "0x#{block_number.to_s(16)}",
        topics: [SWAP_EVENT_HASH],
      }],
      id: 1,
    }

    response = HTTParty.post(POLYGON_RPC_URL, body: payload.to_json, headers: { "Content-Type" => "application/json" })
    if response.success?
      JSON.parse(response.body)["result"]
    else
      []
    end
  rescue => e
    Rails.logger.error "Error fetching swap events: #{e.message}"
    []
  end
end
