package org.p2p.solanaj.Service;

import org.bitcoinj.core.Base58;
import org.p2p.solanaj.core.Account;
import org.p2p.solanaj.core.PublicKey;
import org.p2p.solanaj.core.Transaction;
import org.p2p.solanaj.core.TransactionInstruction;
import org.p2p.solanaj.programs.SystemProgram;
import org.p2p.solanaj.rpc.Cluster;
import org.p2p.solanaj.rpc.RpcClient;
import org.p2p.solanaj.rpc.RpcException;
import org.p2p.solanaj.rpc.types.ConfirmedTransaction;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;

@Service
public class WalletService {

    private final RpcClient rpcClient;
    private final Map<String, Account> walletStore;

    public WalletService() {
        this.rpcClient = new RpcClient(Cluster.MAINNET);
        this.walletStore = new HashMap<>();
    }

    public Account createNewAccount() {
        Account account = new Account();
        walletStore.put(account.getPublicKey().toBase58(), account);
        return account;
    }

    public Account addAccount(String privateKey, String publicKey){
            Account account = new Account(Base58.decode(privateKey));
            walletStore.put(publicKey, account);
            return account;
    }

    public Account getAccount(String publicKey) {
        return walletStore.get(publicKey);
    }

    public Map<String, Account> getAllAccounts() {
        return walletStore;
    }

    public String transferSOL(String fromPublicKey, String toPublicKey, long lamports) throws RpcException {
        Account fromAccount = walletStore.get(fromPublicKey);
        if (fromAccount == null) {
            throw new RpcException("From account not found");
        }

        PublicKey toPublicKeyObj = new PublicKey(toPublicKey);
        Transaction transaction = new Transaction();
        TransactionInstruction instruction = SystemProgram.transfer(fromAccount.getPublicKey(), toPublicKeyObj, lamports);
        transaction.addInstruction(instruction);

        String signature = rpcClient.getApi().sendTransaction(transaction, fromAccount);
        return signature;
    }

    public long getBalance(String publicKey) throws RpcException {
        return rpcClient.getApi().getBalance(new PublicKey(publicKey));
    }

    public ConfirmedTransaction getTransaction(String signature) throws RpcException {
        return rpcClient.getApi().getTransaction(signature);
    }
}