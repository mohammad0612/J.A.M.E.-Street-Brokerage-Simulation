(** Buy module *)

val update_avg : float * float -> float * float -> float
(** [update_avg (a1, f1) (a2, f2)] is the weighted average of [a1] and [a2],
    where [f1] and [f2] are the weights of [a1] and [a2] respectively. *)

val order : (Account.stock * float) list -> (Account.stock * float) list
(** [order lst] returns a list of portfolio entries sorted in ascending order of
    ticker symbol and with any entries for the same ticker symbol combined into
    a single entry. *)

val buy : float -> string -> Account.account -> Account.account
(** [buy shares ticker acc] buys [shares] shares of stock with the given
    [ticker] at the current market price and updates the given account [acc]
    with the resulting changes. *)
