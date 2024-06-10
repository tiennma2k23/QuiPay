package org.p2p.solanaj.Controller;

import org.bitcoinj.core.Base58;
import org.p2p.solanaj.Service.WalletService;
import org.p2p.solanaj.core.Account;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Map;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/solana/wallet")
public class WalletController {

    @Autowired
    private WalletService walletService;

    @GetMapping("/create")
    public String createNewAccount() {
        Account account = walletService.createNewAccount();
        return "Private Key: " + Base58.encode(account.getSecretKey()) + "\nPublic Key: " + account.getPublicKey().toBase58();
    }

    @GetMapping("/all")
    public Map<String, Account> getAllAccounts() {
        return walletService.getAllAccounts();
    }

    @PostMapping("/add_accounts")
    public String addAccount(@RequestParam String publicKey, @RequestParam String privateKey) {
        return String.valueOf(walletService.addAccount(privateKey,publicKey));
    }
}
