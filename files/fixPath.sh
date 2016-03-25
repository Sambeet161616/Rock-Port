sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/config.status
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/rice/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/ruby/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/ruby/lib/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/ruby/lib/include/rice/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/ruby/lib/lib64/ruby/site_ruby/1.8/mkmf-rice.rb
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/ruby/lib/mkmf-rice.rb
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/sample/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/sample/enum/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/sample/inheritance/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/sample/map/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/test/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/test/ext/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/test/ext/t1/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/rice-1.4.2/test/ext/t2/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/.gems/gems/utilrb-1.4.0/ext/Makefile
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/env.sh
sed -i -e "s/\/media\/sd\/rock\/rock/"${BUILD_PREFIX//\//\\\/}"rock/g" $BUILD_PREFIX/rock/external/sisl/patches-autobuild-stamp
rm $BUILD_PREFIX/rock/autoproj/remotes/*
ln -s $BUILD_PREFIX/rock/.remotes/git_git___gitorious_org_orocos_toolchain_autoproj_git_push_to_git_gitorious_org__orocos_toolchain_autoproj_git $BUILD_PREFIX/rock/autoproj/remotes/orocos.toolchain
ln -s $BUILD_PREFIX/rock/.remotes/git_git___gitorious_org_rock_base_package_set_git_push_to_git_gitorious_org__rock_base_package_set_git $BUILD_PREFIX/rock/autoproj/remotes/rock.base
ln -s $BUILD_PREFIX/rock/.remotes/git_git___gitorious_org_rock_toolchain_package_set_git_push_to_git_gitorious_org__rock_toolchain_package_set_git $BUILD_PREFIX/rock/autoproj/remotes/rock.toolchain
