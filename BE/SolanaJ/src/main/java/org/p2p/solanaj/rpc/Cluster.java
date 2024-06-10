package org.p2p.solanaj.rpc;

public enum Cluster {
    DEVNET("https://api.devnet.solana.com"),
    TESTNET("https://api.devnet.solana.com"),
    MAINNET("https://api.devnet.solana.com"),
    ANKR("https://api.devnet.solana.com");

    private String endpoint;

    Cluster(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getEndpoint() {
        return endpoint;
    }
}
