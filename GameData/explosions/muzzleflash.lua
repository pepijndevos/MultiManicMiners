--hunter
--skeeter
--ravager
--mangonel
return {
--hunter
	["huntermuzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 0.95 0.4 0.01   1 0.8 0.35 0.01   1 0.5 0.2 0.01   0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[muzzlefront]],
        length             = 25,
        sidetexture        = [[muzzleside]],
        size               = 3,
        sizegrowth         = -1,
        ttl                = 15,
      },
    },
  },
--skeeter
	["skeetermuzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 0.95 0.4 0.01   1 0.8 0.35 0.01   1 0.5 0.2 0.01   0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[muzzlefront]],
        length             = 17.5,
        sidetexture        = [[muzzleside]],
        size               = 4,
        sizegrowth         = -1,
        ttl                = 15,
      },
    },
  },
  --ravager
	["ravagermuzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 0.5 0.5 0.01   0.85 0.4 0.4 0.01   0.7 0.3 0.3 0.01   0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[muzzlefront]],
        length             = 25,
        sidetexture        = [[muzzleside]],
        size               = 5,
        sizegrowth         = -1,
        ttl                = 15,
      },
    },
  },
   --mangonel
	["mangonelmuzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 0.8 0.4 0.01   0.9 0.7 0.35 0.01   0.8 0.6 0.3 0.01   0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[muzzlefront]],
        length             = 30,
        sidetexture        = [[muzzleside]],
        size               = 9,
        sizegrowth         = -1.2,
        ttl                = 15,
      },
    },
  },
   --bb
	["bbmuzzleflash"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 0.95 0.4 0.01   1 0.8 0.35 0.01   1 0.5 0.2 0.01   0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[muzzlefront]],
        length             = 175,
        sidetexture        = [[muzzleside]],
        size               = 35,
        sizegrowth         = -2,
        ttl                = 35,
      },
    },
  },
}
