require 'dl'
require 'dl/import'

module LibSuperdog
        extend DL::Importer
        dlload './Linux/API/Licensing/C/x86_64/libdog_linux_x86_64_demo.so'
        extern 'dog_status_t DOG_CALLCONV dog_encrypt(dog_handle_t handle,void *buffer,dog_size_t length)'
        extern 'dog_status_t DOG_CALLCONV dog_decrypt(dog_handle_t handle,void *buffer,dog_size_t length);'
end

if __FILE__ == $0
    p LibSuperdog.dog_encrypt('helloworld')
    p LibSuperdog.dog_decrypt(LibSuperdog.dog_encrypt('helloworld'))
end
