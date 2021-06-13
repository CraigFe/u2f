
type t

val create : string -> t

type protocol_error =
  [ `Other_error | `Bad_request | `Configuration_unsupported
  | `Device_ineligible | `Timeout | `Unrecognized of int ]

val pp_protocol_error : Format.formatter -> protocol_error -> unit

type error = [
  | `Protocol of protocol_error
  | `Json_decoding of string * string * string
  | `Base64_decoding of string * string * string
  | `Binary_decoding of string * string * string
  | `Version_mismatch of string * string
  | `Typ_mismatch of string * string
  | `Challenge_mismatch of string * string
  | `Key_handle_mismatch of string * string
  | `Signature_verification of string
]

val pp_error : Format.formatter -> error -> unit

type challenge = string

type key_handle = string

val register_request : t -> challenge * string

val register_response : t -> challenge -> string ->
  (Mirage_crypto_ec.P256.Dsa.pub * key_handle * X509.Certificate.t,
   error) result

val authentication_request : t -> key_handle ->
  challenge * string

val authentication_response : t -> Mirage_crypto_ec.P256.Dsa.pub ->
  key_handle -> challenge -> string ->
  (bool * int32, error) result