RV = Gem::Version.new(RUBY_VERSION)
RV22 = Gem::Version.new("2.2.0")

if RV >= RV22
    require 'fiddle/import'
else
    require 'dl'
    require 'dl/import'
end

require 'ffi'

module LibSuperdog
    if RV >= RV22
        extend Fiddle::Importer
    else
        extend DL::Importer
    end
    dlload './Linux/API/Licensing/C/x86_64/libdog_linux_x86_64_demo.so'
    extend FFI::Library
    WIN = (Object::RUBY_PLATFORM =~ /mswin/i || Object::RUBY_PLATFORM =~ /mingw/i) unless defined?(WIN)
    # OSX = ( Object::RUBY_PLATFORM =~ /(darwin)/i ? true : false ) unless defined?(OSX)
    dog_error_codes = enum(
            :DOG_STATUS_OK, 0,
            :DOG_MEM_RANGE , 1,

            # System is out of memory */
            :DOG_INSUF_MEM , 3,
        
            # Too many open login sessions */
            :DOG_TMOF , 4,
        
            # Access denied */
            :DOG_ACCESS_DENIED ,5,
        
            # Required SuperDog not found */
            :DOG_NOT_FOUND , 7,
        
            # Encryption/decryption data length is too short */
            :DOG_TOO_SHORT , 8,
        
            # Invalid input handle */
            :DOG_INV_HND , 9,
        
            # Specified File ID not recognized by API */
            :DOG_INV_FILEID , 10,
        
            # Invalid XML format */
            :DOG_INV_FORMAT , 15,
        
            # Unable to execute function in this context */
            :DOG_REQ_NOT_SUPP , 16,
        
            # Binary data passed to function does not contain valid update */
            :DOG_INV_UPDATE_OBJ , 17,
        
            # SuperDog to be updated not found */
            :DOG_KEYID_NOT_FOUND , 18,
        
            # Required XML tags not found; Contents in binary data are missing * or invalid */
            
            :DOG_INV_UPDATE_DATA , 19,
        
            # Update not supported by SuperDog */
            :DOG_INV_UPDATE_NOTSUPP , 20,
        
            # Update counter is set incorrectly */
            :DOG_INV_UPDATE_CNTR , 21,
        
            # Invalid Vendor Code passed */
            :DOG_INV_VCODE , 22,
        
            # Passed time value is outside supported value range */
            :DOG_INV_TIME , 24,
        
            # Acknowledge data requested by the update, however the ack_data * input parameter is NULL */
            
            :DOG_NO_ACK_SPACE , 26,
        
            # Program running on a terminal server */
            :DOG_TS_DETECTED , 27,
        
            # Unknown algorithm used in V2C file */
            :DOG_UNKNOWN_ALG , 29,
        
            # Signature verification failed */
            :DOG_INV_SIG , 30,
        
            # Requested Feature not available */
            :DOG_FEATURE_NOT_FOUND , 31,
        
            # Communication error between API and local SuperDog License Manager */
            :DOG_LOCAL_COMM_ERR , 33,
        
            # Vendor Code not recognized by API */
            :DOG_UNKNOWN_VCODE , 34,
        
            # Invalid XML specification */
            :DOG_INV_SPEC , 35,
        
            # Invalid XML scope */
            :DOG_INV_SCOPE , 36,
        
            # Too many SuperDog currently connected */
            :DOG_TOO_MANY_KEYS , 37,
        
            # Session was interrupted */
            :DOG_BROKEN_SESSION , 39,
        
            # Feature has expired */
            :DOG_FEATURE_EXPIRED , 41,
        
            # SuperDog License Manager version too old */
            :DOG_OLD_LM , 42,
        
            # USB error occurred when communicating with a SuperDog */
            :DOG_DEVICE_ERR , 43,
        
            # System time has been tampered with */
            :DOG_TIME_ERR , 45,
        
            # Communication error occurred in secure channel */
            :DOG_SCHAN_ERR , 46,
        
            # Corrupt data exists in secure storage area of SuperDog SL */
            :DOG_STORAGE_CORRUPT , 47,
        
            # Unable to locate a Feature matching the scope */
            :DOG_SCOPE_RESULTS_EMPTY , 50,
        
            :DOG_HARDWARE_MODIFIED , 52,
        
            :DOG_UPDATE_TOO_OLD , 54,
        
            :DOG_UPDATE_TOO_NEW , 55,
        
            # Cloned SuperDog SL secure storage detected */
            :DOG_CLONE_DETECTED , 64,
        
            # Specified V2C update already installed */
            :DOG_UPDATE_ALREADY_ADDED , 65,
        
            # Secure storage ID mismatch */
            :DOG_SECURE_STORE_ID_MISMATCH , 78,
        
            # Unable to locate dynamic library for API */
            :DOG_NO_API_DYLIB , 400,
        
            # Dynamic library for API is invalid */
            :DOG_INV_API_DYLIB , 401,
        
            # Object incorrectly initialized */
            :DOG_INVALID_OBJECT , 500,
        
            # Invalid function parameter */
            :DOG_INVALID_PARAMETER , 501,
        
            # Logging in twice to the same object */
            :DOG_ALREADY_LOGGED_IN , 502,
        
            # Logging out twice of the same object */
            :DOG_ALREADY_LOGGED_OUT , 503,
        
            # Incorrect use of system or platform */
            :DOG_OPERATION_FAILED , 525,
        
            # Requested function not implemented */
            :DOG_NOT_IMPL , 698,
        
            # Internal error occurred in API */
            :DOG_INT_ERR , 699,
        
            :DOG_NEXT_FREE_VALUES ,7001)
    
    typealias "dog_u32_t", "unsigned int"
    typealias "dog_size_t", "dog_u32_t"
    typealias 'HANDLE', 'void*'
    typealias "dog_handle_t","dog_u32_t"
    typealias "dog_status_t", "unsigned int"
    typealias "dog_feature_t", "dog_u32_t"
    typealias "dog_vendor_code_t", "const void*"
    
    unless WIN
        extern 'dog_status_t dog_encrypt(dog_handle_t,HANDLE,dog_size_t)'
        extern 'dog_status_t dog_decrypt(dog_handle_t,HANDLE,dog_size_t)'
        extern 'dog_status_t dog_login(dog_feature_t,dog_vendor_code_t,dog_handle_t*)'
        extern 'dog_status_t dog_logout(dog_handle_t)'
    else
        extern 'dog_status_t __stdcall dog_encrypt(dog_handle_t,HANDLE,dog_size_t)'
        extern 'dog_status_t __stdcall dog_decrypt(dog_handle_t,HANDLE,dog_size_t)'
    end

end

if __FILE__ == $0
    feature = 0
    vender_code =  IO.binread("./Linux/VendorCodes/DEMOMA.hvc")
    dog_handle = '' # keep a pointer
    p LibSuperdog.dog_login(feature,vender_code,dog_handle)
    content = '1234567890123456'
    p LibSuperdog.dog_encrypt(dog_handle,content,content.size)
    # p LibSuperdog.dog_decrypt(LibSuperdog.dog_encrypt('helloworld'))
end
