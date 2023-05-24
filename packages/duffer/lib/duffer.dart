/// A pure dart library offering support for netty-like byte buffer manipulation and binary serialization via a pickle inspired system
library duffer;

export 'src/bytebuf_allocator.dart';
export 'src/bytebuf_base.dart';
export 'src/extensions.dart';
export 'src/pooled.dart';
export 'src/serialization/pickle.dart';
export 'src/serialization/polymorphic.dart';
export 'src/platform.dart';
export 'src/unpooled.dart';
export 'src/utils/constants.dart';
export 'src/utils/migration_utils.dart';
export 'src/utils/sizes.dart';
export 'src/impl/file.dart';