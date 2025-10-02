/* eslint-disable unused-imports/no-unused-vars */
const pageRandom = Math.random()

export function useFactorioRenderingMapping() {
  const combinator = entity => {
    const animations = []
    if (entity.sprites) {
      animations.push(entity.sprites)
    }
    if (entity.activity_led_sprites) {
      animations.push(entity.activity_led_sprites)
    }
    return animations
  }
  const railPictures = entity => {
    let pictures = []
    //TODO needs variations
    if (entity.pictures.west) {
      pictures.push(entity.pictures.west.ties)
      pictures.push(entity.pictures.west.backplates)
      pictures.push(entity.pictures.west.stone_path)
      pictures.push(entity.pictures.west.stone_path_background)
      pictures.push(entity.pictures.west.metals)
    }

    pictures = pictures.filter(Boolean)

    return pictures
  }
  const belts = entity => {
    // to do
    //belt animation set + structure
  }
  const inserters = entity => {
    // to do
  }
  const rollingStock = entity => {
    // to do
    //needs filenames implements
    let animations = [entity.pictures.rotated, entity.wheels.rotated]
    animations = animations.filter(Boolean)
    return animations
  }
  const entityPrototypes = {
    arrow: entity => {
      // ArrowPrototype
    },
    'artillery-flare': entity => {
      // ArtilleryFlarePrototype
    },
    'artillery-projectile': entity => {
      // ArtilleryProjectilePrototype
    },
    beam: entity => {
      // BeamPrototype
    },
    'character-corpse': entity => {
      // CharacterCorpsePrototype
    },
    cliff: entity => {
      // CliffPrototype
      const first = Object.values(entity.orientations)[0]
      if (first) {
        const pictures = []
        if (first.pictures) {
          pictures.push(first.pictures[0])
        }
        if (first.pictures_lower) {
          pictures.push(first.pictures_lower[0])
        }
        // These are sprite variations
        return pictures
      }
    },
    corpse: entity => {
      // CorpsePrototype
    },
    'rail-remnants': entity => {
      // RailRemnantsPrototype
    },
    'deconstructible-tile-proxy': entity => {
      // DeconstructibleTileProxyPrototype
    },
    'entity-ghost': entity => {
      // EntityGhostPrototype
    },
    accumulator: entity => {
      // AccumulatorPrototype
      return [entity.chargable_graphics.charge_animation]
    },
    'agricultural-tower': entity => {
      // AgriculturalTowerPrototype
    },
    'artillery-turret': entity => {
      // ArtilleryTurretPrototype
    },
    'asteroid-collector': entity => {
      // AsteroidCollectorPrototype
    },
    asteroid: entity => {
      // AsteroidPrototype
    },
    beacon: entity => {
      // BeaconPrototype
      const animation_list = entity.graphics_set?.animation_list
      if (animation_list) {
        const animations = animation_list.filter(a => a.always_draw).map(a => a.animation)
        return animations
      } else {
        const animations = []
        if (entity.base_picture) {
          animations.push(entity.base_picture)
        }
        if (entity.animation) {
          animations.push(entity.animation)
        }
        return animations
      }
    },
    boiler: entity => {
      // BoilerPrototype
      const animations = []
      if (entity.pictures) {
        const pictures = entity.pictures.north
        if (pictures.structure) {
          animations.push(pictures.structure)
        }
        if (pictures.fire) {
          animations.push(pictures.fire)
        }
        if (pictures.fire_glow) {
          //todo add blend mode
          //animations.push(pictures.fire_glow)
        }
        return animations
      }
    },
    'burner-generator': entity => {
      // BurnerGeneratorPrototype
    },
    'cargo-bay': entity => {
      // CargoBayPrototype
    },
    'cargo-landing-pad': entity => {
      // CargoLandingPadPrototype
    },
    'cargo-pod': entity => {
      // CargoPodPrototype
    },
    character: entity => {
      // CharacterPrototype
      const armorRandom = Math.ceil(pageRandom * entity.animations.length)
      const armorAnimation = entity.animations[armorRandom]
      const animations = [
        armorAnimation.idle_with_gun,
        armorAnimation.running_with_gun,
        armorAnimation.mining_with_tool
      ]

      const randomAnimation = Math.ceil(pageRandom * animations.length)
      const animation = animations[randomAnimation]
      return [animation]
    },
    'arithmetic-combinator': entity => {
      // ArithmeticCombinatorPrototype
      return combinator(entity)
    },
    'decider-combinator': entity => {
      // DeciderCombinatorPrototype
      return combinator(entity)
    },
    'selector-combinator': entity => {
      // SelectorCombinatorPrototype
      return combinator(entity)
    },
    'constant-combinator': entity => {
      // ConstantCombinatorPrototype
      return combinator(entity)
    },
    container: entity => {
      // ContainerPrototype
      return [entity.picture]
    },
    'logistic-container': entity => {
      // LogisticContainerPrototype
      return [entity.animation]
    },
    'infinity-container': entity => {
      // InfinityContainerPrototype
      return [entity.picture]
    },
    'temporary-container': entity => {
      // TemporaryContainerPrototype
    },
    'assembling-machine': entity => {
      // AssemblingMachinePrototype
      const animations = [entity.graphics_set.idle_animation]
      if (entity.graphics_set.always_draw_idle_animation) {
        //todo handle always draw idle animation
      } else {
        animations[0] = entity.graphics_set.animation
      }
      if (entity.graphics_set.working_visualisations) {
        animations.push(entity.graphics_set.working_visualisations)
      }
      return animations
    },
    'rocket-silo': entity => {
      // RocketSiloPrototype
      const animations = [
        entity.door_back_sprite,
        entity.door_front_sprite,
        entity.base_front_sprite,
        entity.base_day_sprite,
        entity.shadow_sprite
        //entity.hole_sprite
        //entity.hole_light_sprite,
        //entity.rocket_shadow_overlay_sprite,
        //entity.rocket_glow_overlay_sprite
      ].filter(Boolean)
      // too big!
      return animations
    },
    furnace: entity => {
      // FurnacePrototype
      const animations = [entity.graphics_set.animation]
      if (entity.graphics_set.working_visualisations) {
        // todo handle working visualisations
        animations.push(...entity.graphics_set.working_visualisations)
      }
      return animations
    },
    'display-panel': entity => {
      // DisplayPanelPrototype
      return [entity.sprites]
    },
    'electric-energy-interface': entity => {
      // ElectricEnergyInterfacePrototype
    },
    'electric-pole': entity => {
      // ElectricPolePrototype
      return [entity.pictures]
    },
    'unit-spawner': entity => {
      // EnemySpawnerPrototype
      // needs masks working
      return [entity.graphics_set.animations[0]]
    },
    'capture-robot': entity => {
      // CaptureRobotPrototype
    },
    'combat-robot': entity => {
      // CombatRobotPrototype
      return [entity.in_motion]
    },
    'construction-robot': entity => {
      // ConstructionRobotPrototype
      return [entity.in_motion]
    },
    'logistic-robot': entity => {
      // LogisticRobotPrototype
      return [entity.in_motion]
    },
    'fusion-generator': entity => {
      // FusionGeneratorPrototype
    },
    'fusion-reactor': entity => {
      // FusionReactorPrototype
    },
    gate: entity => {
      // GatePrototype
      return [entity.horizontal_animation]
    },
    generator: entity => {
      // GeneratorPrototype
      return [entity.horizontal_animation]
    },
    'heat-interface': entity => {
      // HeatInterfacePrototype
    },
    'heat-pipe': entity => {
      // HeatPipePrototype
      return entity.connection_sprites.straight_horizontal
    },
    inserter: entity => {
      // InserterPrototype
      return inserters(entity)
    },
    lab: entity => {
      // LabPrototype
      // needs masks working
      return [entity.on_animation]
      //return ([entity.off_animation])
    },
    lamp: entity => {
      // LampPrototype
      const animations = []
      if (entity.picture_on) {
        animations.push(entity.picture_on)
      }
      if (entity.picture_off) {
        animations.push(entity.picture_off)
      }
      const animation = animations[Math.floor(pageRandom * animations.length)]
      return [animation]
    },
    'land-mine': entity => {
      // LandMinePrototype
    },
    'lightning-attractor': entity => {
      // LightningAttractorPrototype
    },
    'linked-container': entity => {
      // LinkedContainerPrototype
    },
    market: entity => {
      // MarketPrototype
    },
    'mining-drill': entity => {
      // MiningDrillPrototype
      if (entity.base_picture) {
        //needs to handle sheets
        return [entity.base_picture, entity.graphics_set.animation]
      }
      if (entity.graphics_set) {
        //needs a lot more work
        return [entity.graphics_set.animation]
      }
    },
    'offshore-pump': entity => {
      // OffshorePumpPrototype
      // todo a bit broken
      return [entity.graphics_set.base_pictures]
    },
    pipe: entity => {
      // PipePrototype
      return [entity.pictures.straight_horizontal]
    },
    'infinity-pipe': entity => {
      // InfinityPipePrototype
    },
    'pipe-to-ground': entity => {
      // PipeToGroundPrototype
      return [entity.pictures.west]
    },
    'player-port': entity => {
      // PlayerPortPrototype
    },
    'power-switch': entity => {
      // PowerSwitchPrototype
      return [entity.power_on_animation]
    },
    'programmable-speaker': entity => {
      // ProgrammableSpeakerPrototype
      return [entity.sprite]
    },
    'proxy-container': entity => {
      // ProxyContainerPrototype
    },
    pump: entity => {
      // PumpPrototype
      return [entity.animations]
    },
    radar: entity => {
      // RadarPrototype
      // no idea how it spins!
      return [entity.pictures]
    },
    'curved-rail-a': entity => {
      // CurvedRailAPrototype
      return railPictures(entity)
    },
    'elevated-curved-rail-a': entity => {
      // ElevatedCurvedRailAPrototype
      return railPictures(entity)
    },
    'curved-rail-b': entity => {
      // CurvedRailBPrototype
      return railPictures(entity)
    },
    'elevated-curved-rail-b': entity => {
      // ElevatedCurvedRailBPrototype
      return railPictures(entity)
    },
    'half-diagonal-rail': entity => {
      // HalfDiagonalRailPrototype
      return railPictures(entity)
    },
    'elevated-half-diagonal-rail': entity => {
      // ElevatedHalfDiagonalRailPrototype
      return railPictures(entity)
    },
    'legacy-curved-rail': entity => {
      // LegacyCurvedRailPrototype
      return railPictures(entity)
    },
    'legacy-straight-rail': entity => {
      // LegacyStraightRailPrototype
      return railPictures(entity)
    },
    'rail-ramp': entity => {
      // RailRampPrototype
      return railPictures(entity)
    },
    'straight-rail': entity => {
      // StraightRailPrototype
      return railPictures(entity)
    },
    'elevated-straight-rail': entity => {
      // ElevatedStraightRailPrototype
      return railPictures(entity)
    },
    'rail-chain-signal': entity => {
      // RailChainSignalPrototype
      let pictures = []
      const groundPictureSet = entity.ground_picture_set
      if (groundPictureSet) {
        pictures.push(groundPictureSet.structure)
        pictures.push(groundPictureSet.rail_piece)
        pictures.push(groundPictureSet.upper_rail_piece)
      }
      pictures = pictures.filter(Boolean)
      return pictures
    },
    'rail-signal': entity => {
      // RailSignalPrototype
      let pictures = []
      const groundPictureSet = entity.ground_picture_set
      if (groundPictureSet) {
        pictures.push(groundPictureSet.structure)
        pictures.push(groundPictureSet.rail_piece)
        pictures.push(groundPictureSet.upper_rail_piece)
      }
      pictures = pictures.filter(Boolean)
      return pictures
    },
    'rail-support': entity => {
      // RailSupportPrototype
      return [entity.graphics_set.structure]
    },
    reactor: entity => {
      // ReactorPrototype
      // needs blending working
      return [entity.picture, entity.working_light_picture]
    },
    roboport: entity => {
      // RoboportPrototype
      return [
        entity.base,
        entity.base_animation,
        entity.door_animation_up,
        entity.door_animation_down
      ]
    },
    segment: entity => {
      // SegmentPrototype
    },
    'segmented-unit': entity => {
      // SegmentedUnitPrototype
    },
    'simple-entity-with-owner': entity => {
      // SimpleEntityWithOwnerPrototype
      return [entity.pictures[0]]
    },
    'simple-entity-with-force': entity => {
      // SimpleEntityWithForcePrototype
      return [entity.pictures[0]]
    },
    'solar-panel': entity => {
      // SolarPanelPrototype
      return [entity.picture]
    },
    'space-platform-hub': entity => {
      // SpacePlatformHubPrototype
    },
    'spider-leg': entity => {
      // SpiderLegPrototype
    },
    'spider-unit': entity => {
      // SpiderUnitPrototype
    },
    'storage-tank': entity => {
      // StorageTankPrototype
      const tankPictures = entity.pictures
      //needs sheets working
      return [tankPictures.picture]
    },
    thruster: entity => {
      // ThrusterPrototype
    },
    'train-stop': entity => {
      // TrainStopPrototype
      let animations = [entity.rail_overlay_animations, entity.animations, entity.top_animations]
      animations = animations.filter(Boolean)
      return animations
    },
    'lane-splitter': entity => {
      // LaneSplitterPrototype
      return belts(entity)
    },
    'linked-belt': entity => {
      // LinkedBeltPrototype
    },
    'loader-1x1': entity => {
      // Loader1x1Prototype
    },
    loader: entity => {
      // Loader1x2Prototype
    },
    splitter: entity => {
      // SplitterPrototype
      return belts(entity)
    },
    'transport-belt': entity => {
      // TransportBeltPrototype
      return belts(entity)
    },
    'underground-belt': entity => {
      // UndergroundBeltPrototype
      return belts(entity)
    },
    turret: entity => {
      // TurretPrototype
      // needs stripes working
      return [entity.prepared_animation]
    },
    'ammo-turret': entity => {
      // AmmoTurretPrototype
      return [entity.prepared_animation]
    },
    'electric-turret': entity => {
      // ElectricTurretPrototype
      return [entity.prepared_animation]
    },
    'fluid-turret': entity => {
      // FluidTurretPrototype
      return [entity.prepared_animation]
    },
    unit: entity => {
      // UnitPrototype
      return entity.run_animation
    },
    valve: entity => {
      // ValvePrototype
      return [entity.animations]
    },
    car: entity => {
      // CarPrototype
      return [entity.animation]
    },
    'artillery-wagon': entity => {
      // ArtilleryWagonPrototype
      return rollingStock(entity)
    },
    'cargo-wagon': entity => {
      // CargoWagonPrototype
      return rollingStock(entity)
    },
    'infinity-cargo-wagon': entity => {
      // InfinityCargoWagonPrototype
      return rollingStock(entity)
    },
    'fluid-wagon': entity => {
      // FluidWagonPrototype
      return rollingStock(entity)
    },
    locomotive: entity => {
      // LocomotivePrototype
      return rollingStock(entity)
    },
    'spider-vehicle': entity => {
      // SpiderVehiclePrototype
    },
    wall: entity => {
      // WallPrototype
      return [entity.pictures.straight_horizontal]
    },
    fish: entity => {
      // FishPrototype
      return [entity.pictures[0]]
    },
    'simple-entity': entity => {
      // SimpleEntityPrototype
      return [entity.pictures[0]]
    },
    tree: entity => {
      // TreePrototype needs extra stuff
      return [entity.pictures[0]]
    },
    plant: entity => {
      // PlantPrototype
    },
    explosion: entity => {
      // ExplosionPrototype
    },
    fire: entity => {
      // FireFlamePrototype
    },
    stream: entity => {
      // FluidStreamPrototype
    },
    'highlight-box': entity => {
      // HighlightBoxEntityPrototype
    },
    'item-entity': entity => {
      // ItemEntityPrototype
    },
    'item-request-proxy': entity => {
      // ItemRequestProxyPrototype
    },
    lightning: entity => {
      // LightningPrototype
    },
    'particle-source': entity => {
      // ParticleSourcePrototype
    },
    projectile: entity => {
      // ProjectilePrototype
    },
    resource: entity => {
      // ResourceEntityPrototype
      return [entity.stages]
    },
    'rocket-silo-rocket': entity => {
      // RocketSiloRocketPrototype
    },
    'rocket-silo-rocket-shadow': entity => {
      // RocketSiloRocketShadowPrototype
    },
    'smoke-with-trigger': entity => {
      // SmokeWithTriggerPrototype
    },
    'speech-bubble': entity => {
      // SpeechBubblePrototype
    },
    sticker: entity => {
      // StickerPrototype
    },
    'tile-ghost': entity => {
      // TileGhostPrototype
    },
    // Abstract entities
    abstract: entity => {
      // SmokePrototype
      // EntityWithHealthPrototype
      // EntityWithOwnerPrototype
      // CombinatorPrototype
      // CraftingMachinePrototype
      // FlyingRobotPrototype
      // RobotWithLogisticInterfacePrototype
      // RailPrototype
      // RailSignalBasePrototype
      // TransportBeltConnectablePrototype
      // LoaderPrototype
      // VehiclePrototype
      // RollingStockPrototype
    }
  }

  return {
    getRenderingMethod: animationData => {
      return entityPrototypes[animationData.type]?.(animationData) || null
    }
  }
}
