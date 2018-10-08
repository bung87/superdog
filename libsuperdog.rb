RV = Gem::Version.new(RUBY_VERSION)
RV22 = Gem::Version.new("2.2.0")

if RV >= RV22
    require 'fiddle/import'
else
    require 'dl'
    require 'dl/import'
end

module LibSuperdog
        if RV >= RV22
            extend Fiddle::Importer
        else
            extend DL::Importer
        end
        dlload './Linux/API/Licensing/C/x86_64/libdog_linux_x86_64_demo.so'
        extern 'dog_status_t DOG_CALLCONV dog_encrypt(dog_handle_t handle,void *buffer,dog_size_t length)'
        extern 'dog_status_t DOG_CALLCONV dog_decrypt(dog_handle_t handle,void *buffer,dog_size_t length);'
end

if __FILE__ == $0
    p LibSuperdog.dog_encrypt('helloworld')
    p LibSuperdog.dog_decrypt(LibSuperdog.dog_encrypt('helloworld'))
end
