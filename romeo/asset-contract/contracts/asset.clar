;; title: wrapped BTC on Stacks
;; version: 0.1.0
;; summary: sBTC dev release asset contract
;; description: sBTC is a wrapped BTC asset on Stacks.
;; It is a fungible token (SIP-10) that is backed 1:1 by BTC
;; For this version the wallet is controlled by a centralized entity.
;; sBTC is minted when BTC is deposited into the wallet and
;; burned when BTC is withdrawn from the wallet.
;; Requests for minting and burning are made by the contract owner.

;; traits
;;
(impl-trait 'ST1NXBK3K5YYMD6FD41MVNP3JS1GABZ8TRVX023PT.sip-010-trait-ft-standard.sip-010-trait)

;; token definitions
;;
(define-fungible-token sbtc u21000000000000)

;; constants
;;
(define-constant err-forbidden (err u403))

;; data vars
;;
(define-data-var contract-owner principal tx-sender)
(define-data-var bitcoin-wallet-public-key (optional (buff 33)) none)

;; public functions
;;
(define-public (set-bitcoin-wallet-public-key (public-key (buff 33)))
    (begin
        (asserts! (is-contract-owner) err-forbidden)
        (ok (var-set bitcoin-wallet-public-key (some public-key)))
    )
)

(define-public (mint (amount uint) (dst principal) (deposit-txid (string-ascii 72)))
    (begin
        (asserts! (is-contract-owner) err-forbidden)
        ;; TODO #79: Assert deposit-txid exists on chain
        (print {notification: "mint", payload: deposit-txid})
        (ft-mint? sbtc amount dst)
    )
)

(define-public (burn (amount uint) (src principal) (withdraw-txid (string-ascii 72)))
    (begin
        (asserts! (is-contract-owner) err-forbidden)
        ;; TODO #79: Assert withdraw-txid exists on chain
        (print {notification: "burn", payload: withdraw-txid})
        (ft-burn? sbtc amount src)
    )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (is-eq tx-sender sender) err-forbidden)
		(try! (ft-transfer? sbtc amount sender recipient))
		(match memo to-print (print to-print) 0x)
		(ok true)
	)
)

;; read only functions
;;
(define-read-only (get-bitcoin-wallet-public-key)
    (var-get bitcoin-wallet-public-key)
)

(define-read-only (get-name)
	(ok "sBTC")
)

(define-read-only (get-symbol)
	(ok "sBTC")
)

(define-read-only (get-decimals)
	(ok u8)
)

(define-read-only (get-balance (who principal))
	(ok (ft-get-balance sbtc who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply sbtc))
)

(define-read-only (get-token-uri)
	(ok (some u"https://assets.stacks.co/sbtc.pdf"))
)

;; private functions
;;
(define-private (is-contract-owner)
    (is-eq (var-get contract-owner) tx-sender)
)
