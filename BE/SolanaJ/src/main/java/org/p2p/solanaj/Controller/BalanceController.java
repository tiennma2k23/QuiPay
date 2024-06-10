package org.p2p.solanaj.Controller;

import org.p2p.solanaj.Service.WalletService;
import org.p2p.solanaj.core.Account;
import org.p2p.solanaj.core.PublicKey;
import org.p2p.solanaj.rpc.RpcClient;
import org.p2p.solanaj.rpc.RpcException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/solana/balance")
public class BalanceController {

    @Autowired
    private WalletService walletService;

    @GetMapping("/get")
    public String getBalance(@RequestParam String publicKey) {
        try {
            long balance = walletService.getBalance(publicKey);
            return "Balance: " + balance + " lamports";
        } catch (RpcException e) {
            return "Error retrieving balance: " + e.getMessage();
        }
    }

}