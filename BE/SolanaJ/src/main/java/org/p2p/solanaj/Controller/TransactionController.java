package org.p2p.solanaj.Controller;

import org.p2p.solanaj.Service.WalletService;
import org.p2p.solanaj.rpc.RpcException;
import org.p2p.solanaj.rpc.types.ConfirmedTransaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/solana/transaction")
public class TransactionController {

    @Autowired
    private WalletService walletService;

    @GetMapping("/get")
    public String getTransaction(@RequestParam String signature) {
        try {
            ConfirmedTransaction transaction = walletService.getTransaction(signature);
            return transaction.toString();
        } catch (RpcException e) {
            return "Error retrieving transaction: " + e.getMessage();
        }
    }

    @PostMapping("/send")
    public String sendTransaction(@RequestParam String fromPublicKey, @RequestParam String toPublicKey, @RequestParam long lamports) {
        try {
            return walletService.transferSOL(fromPublicKey, toPublicKey, lamports);
        } catch (RpcException e) {
            return "Error during transaction: " + e.getMessage();
        }
    }
}