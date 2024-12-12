pub const packages = struct {
    pub const @"122058d3ea6318efb819d0bffba630afd1a459fa3a99b4bfe4b680a937d5de04d2fc" = struct {
        pub const build_root = "/home/jan/.cache/zig/p/122058d3ea6318efb819d0bffba630afd1a459fa3a99b4bfe4b680a937d5de04d2fc";
        pub const build_zig = @import("122058d3ea6318efb819d0bffba630afd1a459fa3a99b4bfe4b680a937d5de04d2fc");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "raylib", "1220d93782859726c2c46a05450615b7edfc82b7319daac50cbc7c3345d660b022d7" },
            .{ "raygui", "122062b24f031e68f0d11c91dfc32aed5baf06caf26ed3c80ea1802f9e788ef1c358" },
        };
    };
    pub const @"122062b24f031e68f0d11c91dfc32aed5baf06caf26ed3c80ea1802f9e788ef1c358" = struct {
        pub const build_root = "/home/jan/.cache/zig/p/122062b24f031e68f0d11c91dfc32aed5baf06caf26ed3c80ea1802f9e788ef1c358";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"12208da4dfcd9b53fb367375fb612ec73f38e53015f1ce6ae6d6e8437a637078e170" = struct {
        pub const available = false;
    };
    pub const @"1220d93782859726c2c46a05450615b7edfc82b7319daac50cbc7c3345d660b022d7" = struct {
        pub const build_root = "/home/jan/.cache/zig/p/1220d93782859726c2c46a05450615b7edfc82b7319daac50cbc7c3345d660b022d7";
        pub const build_zig = @import("1220d93782859726c2c46a05450615b7edfc82b7319daac50cbc7c3345d660b022d7");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "xcode_frameworks", "12208da4dfcd9b53fb367375fb612ec73f38e53015f1ce6ae6d6e8437a637078e170" },
            .{ "emsdk", "1220e8fe9509f0843e5e22326300ca415c27afbfbba3992f3c3184d71613540b5564" },
        };
    };
    pub const @"1220e8fe9509f0843e5e22326300ca415c27afbfbba3992f3c3184d71613540b5564" = struct {
        pub const available = false;
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "raylib-zig", "122058d3ea6318efb819d0bffba630afd1a459fa3a99b4bfe4b680a937d5de04d2fc" },
};
