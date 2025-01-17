import { KeySorts, fetchKey, PKG_URL } from './utils'

// This example uses demo credentials.
// Anyone get retrieve an instance with custom data at the following URL:
// https://privacybydesign.foundation/attribute-index/en/irma-demo.gemeente.personalData.html

const modPromise = import('@e4a/pg-wasm')

window.postguard = {
    issuer: {
        email: 'irma-demo.sidn-pbdf.email.email',
        fullname: 'irma-demo.gemeente.personalData.fullname',
        bsn: 'irma-demo.gemeente.personalData.bsn',
    },

    get_recipient_name: function (email) {
        // Return the full email, which will be used as the key in the
        // encryption policy. A hacky solution to make it easy to
        // populate a selection menu with recipients' email addresses
        // on the download page.
        return email // email.split('@')[0]
    },

    /**
     * Convert a hex encode password into a Uint8Array
     */
    decode_password: function (encoded_password) {
        return Uint8Array.from(encoded_password.match(/.{1,2}/g).map((byte) => parseInt(byte, 16)))
    },

    /**
     * Call callback on the header of hex encode password encoded_password.
     * If the callback is not supplied return the unsealer and the header.
     * The return value is undefined if errors occur during unsealing.
     */
    get_ct_header: async function (encoded_password, callback, onerror) {
        const { Unsealer } = await modPromise
    
        const vk = await fetch(`${PKG_URL}/v2/sign/parameters`)
            .then((r) => r.json())
            .then((j) => j.publicKey)
    
        // console.log(this)
        const ct = this.decode_password(encoded_password)
        var err_msg = 'Error during unsealing'
    
        try {
            const unsealer = await Unsealer.new(ct, vk)
            const header = unsealer.inspect_header()
            if(callback) {
                callback(header)
            } else {
                return {
                    "unsealer": unsealer,
                    "header": header
                }
            }
        } catch (e) {
            console.log(e)
            if( onerror ) { onerror(err_msg) }
        }
    },
}

window.postguard.encrypt = async function (input, from, recipients, callback, onerror) {
    // const input = document.getElementById('plain').value
    console.log('input: ', input)

    const { seal } = await modPromise
    console.log('loaded WASM module: ', seal)

    const mpk = await fetch(`${PKG_URL}/v2/parameters`)
        .then((r) => r.json())
        .then((j) => j.publicKey)

    console.log('retrieved public key: ', mpk)

    const policy = recipients.reduce((acc, recipient) => {
        var recipient_name = this.get_recipient_name(recipient)
        return { ...acc, [recipient_name]: {
            ts: Math.round(Date.now() / 1000),
            con: [{ t: this.issuer.email, v: recipient }]
        }}}, {}
    )

    // This policy is visible to everyone.
    const pubSignId = [{ t: this.issuer.email, v: from }]

    // This policy is only visible to recipients.
    // const privSignId = [{ t: this.issuer.bsn, v: '1234' }] // remove this

    // We retrieve keys for these policies.
    let { pubSignKey, privSignKey } = await fetchKey(
        KeySorts.Signing,
        { con: [...pubSignId]}, //, ...privSignId] },
        undefined,
        { pubSignId, } // privSignId }
    )
    console.log('got public signing key for Alice: ', pubSignKey)
    console.log('got private signing key for Alice: ', privSignKey)

    const sealOptions = {
        policy,
        pubSignKey,
        privSignKey,
    }

    const encoded = new TextEncoder().encode(input)
    const t0 = performance.now()

    try {
        var ct = await seal(mpk, sealOptions, encoded)
        const tEncrypt = performance.now() - t0

        console.log(`tEncrypt ${tEncrypt}$ ms`)
        console.log('ct: ', ct)

        // const outputEl = document.getElementById('ciphertext')
        // outputEl.value = ct

        // TODO: converting a uint8array to a hex string can be optimized with: https://www.xaymar.com/articles/2020/12/08/fastest-uint8array-to-hex-string-conversion-in-javascript/
        var pg_password = Array.from(ct)
            .map((i) => i.toString(16).padStart(2, '0'))
            .join('')
        callback(pg_password)
    } catch (e) {
        console.log('error during sealing: ', e)
        if( onerror ) { onerror() }
    }
}

window.postguard.decrypt = async function (encoded_password, pg_attribute, callback, onerror) {
    var err_msg = 'Error during unsealing'
    const unsealer_header = await this.get_ct_header(encoded_password)

    try {
        if(!unsealer_header || !unsealer_header.header || !unsealer_header.unsealer) {
            throw new Error('Error during unsealing.')
        }

        const unsealer = unsealer_header.unsealer
        const header = unsealer_header.header
        const recipient_name = this.get_recipient_name(pg_attribute)
        if(!header.has(recipient_name)) {
            err_msg = 'Pick a different attribute.'
            throw new Error('Wrong PostGuard Attribute')
        }

        const keyRequest = {
            con: [{ t: this.issuer.email, v: pg_attribute }],
        }
        const timestamp = header.get(recipient_name).ts
        const usk = await fetchKey(KeySorts.Encryption, keyRequest, timestamp)

        console.log('retrieved usk: ', usk)

        const t0 = performance.now()
        const [plain, policy] = await unsealer.unseal(recipient_name, usk)

        const tDecrypt = performance.now() - t0

        console.log(`tDecrypt ${tDecrypt}$ ms`)

        const original = new TextDecoder().decode(plain)
        // document.getElementById('original').textContent = original
        // document.getElementById('sender').textContent = JSON.stringify(policy)
        callback(original)
    } catch (e) {
        console.log('error during unsealing: ', e)
        if( onerror ) { onerror(err_msg) }
    }
}

// window.onload = async () => {
//     const encBtn = document.getElementById('encrypt-btn')
//     encBtn.addEventListener('click', pg_encrypt)

//     const decBtn = document.getElementById('decrypt-btn')
//     decBtn.addEventListener('click', pg_decrypt)
// }