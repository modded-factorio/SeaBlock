<template>
  <div :class="$style.detailsPane">
    <div v-if="selectedItem" :class="$style.itemDetails">
      <!-- Item Header with Controls and Tabs -->
      <div :class="$style.itemHeader">
        <div :class="$style.headerTitle">
          <IconButton
            :type="getPrimaryType(selectedItem)"
            :name="selectedItem.name"
            :size="36"
            :clickable="false"
          />
          <h3>{{ selectedItem.displayName }} ({{ itemTypeLabel }})</h3>
        </div>
        <div :class="$style.headerTabs">
          <button
            :class="{ [$style.active]: activeTab === 'details' }"
            @click="activeTab = 'details'"
          >
            Details
          </button>
          <button :class="{ [$style.active]: activeTab === 'raws' }" @click="activeTab = 'raws'">
            Raws
          </button>
        </div>
      </div>

      <!-- Large Item Image (for entities and items) -->
      <div
        v-if="isEntity || selectedItem.types?.includes('item')"
        :class="$style.itemImageContainer"
      >
        <FactorioSprite
          v-if="entitySpriteData && isEntity"
          :key="type + name"
          :sprite-data="entitySpriteData"
          :size="128"
          :play-animation="!isAnimationPaused"
          :is-paused="isAnimationPaused"
          @toggle-pause="emit('toggle-animation-pause')"
        />
        <IconButton
          v-else
          :type="getPrimaryType(selectedItem)"
          :name="selectedItem.name"
          :size="128"
          :clickable="false"
        />
      </div>

      <!-- Usage Description -->
      <div
        v-if="selectedItem.description && activeTab === 'details'"
        :class="$style.usageDescription"
      ></div>
      <!-- Details Tab Content -->
      <div v-if="activeTab === 'details'">
        <p>{{ selectedItem.description }}</p>
        <!-- Statistics -->
        <div :class="$style.statistics">
          <div v-for="stat in statisticsData" :key="stat.label" :class="$style.statItem">
            <SpriteIcon v-if="stat.icon" :sprite-key="stat.icon" :size="16" />
            <strong>{{ stat.label }}:</strong>
            <template v-if="stat.children">
              <ul v-if="stat.children.length > 0" :class="$style.resistanceList">
                <li v-for="child in stat.children" :key="child.label">
                  <template v-if="child.children">
                    <strong>{{ child.label }}:</strong>
                    <ul v-if="child.children.length > 0" :class="$style.resistanceList">
                      <li v-for="grandchild in child.children" :key="grandchild.label">
                        {{ grandchild.label }}: {{ grandchild.value }}
                      </li>
                    </ul>
                  </template>
                  <template v-else> {{ child.label }}: {{ child.value }} </template>
                </li>
              </ul>
            </template>
            <template v-else>
              {{ stat.value }}
            </template>
          </div>

          <!-- Electricity Consumption -->
          <div v-if="hasElectricityConsumption" :class="$style.electricityConsumption">
            <div :class="$style.electricitySection">
              <SpriteIcon sprite-key="utility-electricity" :size="16" color="#ffeb3b" />
              <span>Consumes electricity</span>
            </div>
            <div v-if="entityEnergyUsage" :class="$style.energyDetails">
              <div v-if="entityEnergyUsage.max" :class="$style.energyItem">
                <strong>Max. consumption:</strong> {{ entityEnergyUsage.max }} kW
              </div>
              <div v-if="entityEnergyUsage.min" :class="$style.energyItem">
                <strong>Min. consumption:</strong> {{ entityEnergyUsage.min }} kW
              </div>
            </div>
          </div>

          <!-- Power Generation -->
          <div v-if="hasPowerGeneration" :class="$style.powerGeneration">
            <div :class="$style.powerSection">
              <SpriteIcon sprite-key="utility-electricity" :size="16" />
              <span>Generates electricity</span>
            </div>
            <div v-if="powerOutput" :class="$style.powerOutput">
              <strong>Max. output:</strong> {{ powerOutput }} kW
            </div>
          </div>

          <!-- Recipe-specific content -->
          <template v-if="selectedItem.types?.includes('recipe') && selectedItem.recipe">
            <!-- Ingredients -->
            <div v-if="selectedItem.recipe.ingredients?.length > 0" :class="$style.recipeSection">
              <h4 title="Items required to craft this recipe">Ingredients:</h4>
              <div :class="$style.ingredientsList">
                <div
                  v-for="ingredient in selectedItem.recipe.ingredients"
                  :key="`${ingredient.name}-${ingredient.amount}`"
                  :class="$style.ingredientItem"
                >
                  <IconButton
                    :type="ingredient.type"
                    :name="ingredient.name"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick(ingredient.type, ingredient.name)"
                  />
                  <span
                    >{{ ingredient.amount }} ×
                    {{ getDisplayName(ingredient.name, ingredient.type) }}</span
                  >
                </div>
              </div>

              <!-- Crafting Time -->
              <div v-if="selectedItem.recipe.energyRequired" :class="$style.craftingTimeContainer">
                <hr :class="$style.craftingTimeHr" />
                <div :class="$style.craftingTime">
                  <SpriteIcon sprite-key="utility-time" :size="16" />
                  <span>{{ selectedItem.recipe.energyRequired }}s Crafting time</span>
                </div>
              </div>
            </div>

            <!-- Results (only for multi-product recipes) -->
            <div v-if="selectedItem.recipe.results?.length > 1" :class="$style.recipeSection">
              <h4 title="Items produced by this recipe">Results:</h4>
              <div
                v-for="result in selectedItem.recipe.results"
                :key="`${result.name}-${result.amount}`"
                :class="$style.productItem"
              >
                <IconButton
                  :type="result.type"
                  :name="result.name"
                  :size="36"
                  :clickable="true"
                  @click="handleIconClick(result.type, result.name)"
                />
                <span>{{ result.amount }} × {{ getDisplayName(result.name, result.type) }}</span>
              </div>
            </div>

            <!-- Made in -->
            <div v-if="madeInBuildings.length > 0" :class="$style.recipeSection">
              <h4 title="Building or machine required to craft this recipe">Made in:</h4>
              <div :class="$style.madeInGrid">
                <div
                  v-for="building in madeInBuildings"
                  :key="building.name"
                  :class="$style.madeInItem"
                >
                  <IconButton
                    type="entity"
                    :name="building.name"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick('building', building.name)"
                  />
                </div>
              </div>
            </div>

            <!-- Used in -->
            <div v-if="usedInRecipes.length > 0" :class="$style.recipeSection">
              <h4 title="Recipes that use this item as an ingredient">Used in:</h4>
              <div :class="$style.buttonGrid">
                <div v-for="recipe in usedInRecipes" :key="recipe.name" :class="$style.gridItem">
                  <IconButton
                    type="recipe"
                    :name="recipe.name"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick('recipe', recipe.name, recipe)"
                  />
                </div>
              </div>
            </div>

            <!-- Can Craft -->
            <div v-if="isEntity && canCraftRecipes.length > 0" :class="$style.recipeSection">
              <h4 title="Recipes that can be crafted in this building">Can craft:</h4>
              <div :class="$style.canCraftGrid">
                <div
                  v-for="recipe in canCraftRecipes"
                  :key="recipe.name"
                  :class="$style.canCraftItem"
                >
                  <IconButton
                    type="recipe"
                    :name="recipe.name"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick('recipe', recipe.name)"
                  />
                </div>
              </div>
            </div>
          </template>

          <!-- Technology-specific content -->
          <template v-if="selectedItem.types?.includes('technology') && selectedItem.technology">
            <div :class="$style.technologySection">
              <h4>Technology Details</h4>

              <!-- Research Trigger (Primary Unlock) -->
              <div v-if="selectedItem.technology.research_trigger" :class="$style.researchTrigger">
                <h5>Unlock Requirement:</h5>
                <div :class="$style.triggerDetails">
                  <div
                    v-if="selectedItem.technology.research_trigger.type === 'craft-item'"
                    :class="$style.triggerItem"
                  >
                    <SpriteIcon sprite-key="utility-craft" :size="16" />
                    <strong>Craft:</strong>
                    <IconButton
                      type="item"
                      :name="selectedItem.technology.research_trigger.item"
                      :size="20"
                      :clickable="true"
                      @click="
                        handleIconClick('item', selectedItem.technology.research_trigger.item)
                      "
                    />
                    {{ selectedItem.technology.research_trigger.count || 1 }} ×
                    {{ getDisplayName(selectedItem.technology.research_trigger.item, 'item') }}
                  </div>
                  <div
                    v-else-if="selectedItem.technology.research_trigger.type === 'mine-entity'"
                    :class="$style.triggerItem"
                  >
                    <SpriteIcon sprite-key="utility-mining" :size="16" />
                    <strong>Mine:</strong>
                    <IconButton
                      type="entity"
                      :name="selectedItem.technology.research_trigger.entity"
                      :size="20"
                      :clickable="true"
                      @click="
                        handleIconClick('entity', selectedItem.technology.research_trigger.entity)
                      "
                    />
                    {{ getDisplayName(selectedItem.technology.research_trigger.entity) }}
                  </div>
                  <div
                    v-else-if="
                      selectedItem.technology.research_trigger.type === 'send-item-to-orbit'
                    "
                    :class="$style.triggerItem"
                  >
                    <SpriteIcon sprite-key="utility-rocket" :size="16" />
                    <strong>Send to orbit:</strong>
                    <IconButton
                      type="item"
                      :name="selectedItem.technology.research_trigger.item"
                      :size="20"
                      :clickable="true"
                      @click="
                        handleIconClick('item', selectedItem.technology.research_trigger.item)
                      "
                    />
                    {{ getDisplayName(selectedItem.technology.research_trigger.item, 'item') }}
                  </div>
                  <div v-else :class="$style.triggerItem">
                    <SpriteIcon sprite-key="utility-trigger" :size="16" />
                    <strong>{{ selectedItem.technology.research_trigger.type }}:</strong>
                    {{
                      selectedItem.technology.research_trigger.item ||
                      selectedItem.technology.research_trigger.entity
                    }}
                  </div>
                </div>
              </div>

              <!-- Research Cost -->
              <div v-if="selectedItem.technology.unit" :class="$style.researchCost">
                <h5>Research Cost:</h5>
                <div :class="$style.costDetails">
                  <!-- Research Time and Count (separate lines) -->
                  <div :class="$style.researchTimeSection">
                    <div :class="$style.researchTimeItem">
                      <SpriteIcon sprite-key="utility-time" :size="16" />
                      <strong>Research time:</strong> {{ selectedItem.technology.unit.time || 30 }}s
                    </div>
                    <div :class="$style.researchCountItem">
                      <strong>Research count:</strong> {{ selectedItem.technology.unit.count }}
                    </div>
                  </div>

                  <!-- Science Packs -->
                  <div
                    v-if="selectedItem.technology.unit.ingredients?.length > 0"
                    :class="$style.sciencePacksSection"
                  >
                    <div :class="$style.sciencePacksList">
                      <div
                        v-for="pack in selectedItem.technology.unit.ingredients"
                        :key="pack[0] || pack.name"
                        :class="$style.sciencePackItem"
                      >
                        <IconButton
                          type="recipe"
                          :name="pack[0] || pack.name"
                          :size="24"
                          :clickable="true"
                          @click="handleIconClick('recipe', pack[0] || pack.name)"
                        />
                        <span
                          >{{ pack[1] || pack.amount }} ×
                          {{ getDisplayName(pack[0], 'item') }}</span
                        >
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Prerequisites -->
              <div v-if="selectedItem.technology.prerequisites?.length > 0">
                <h4>Prerequisites:</h4>
                <div :class="$style.buttonGrid">
                  <div
                    v-for="prereq in selectedItem.technology.prerequisites"
                    :key="prereq"
                    :class="$style.gridItem"
                    @click="selectTechnology(prereq)"
                  >
                    <IconButton
                      type="technology"
                      :name="prereq"
                      :size="36"
                      :clickable="true"
                      @click="handleIconClick('technology', prereq)"
                    />
                  </div>
                </div>
              </div>

              <!-- Technology Level Info -->
              <div
                v-if="selectedItem.technology.maxLevel || selectedItem.technology.upgrade"
                :class="$style.technologyLevel"
              >
                <h5>Technology Level:</h5>
                <div :class="$style.levelInfo">
                  <div v-if="selectedItem.technology.maxLevel" :class="$style.levelItem">
                    <strong>Max level:</strong> {{ selectedItem.technology.maxLevel }}
                  </div>
                  <div v-if="selectedItem.technology.upgrade" :class="$style.levelItem">
                    <strong>Upgrade technology:</strong> Yes
                  </div>
                </div>
              </div>

              <!-- Effects -->
              <div v-if="selectedItem.technology.effects?.length > 0">
                <h4>Effects:</h4>
                <div :class="$style.buttonGrid">
                  <div
                    v-for="effect in selectedItem.technology.effects"
                    :key="`${effect.type}-${effect.recipe || effect.modifier || effect.ammoCategory}`"
                    :class="$style.gridItem"
                  >
                    <!-- Unlock recipe effects - show recipe icon -->
                    <IconButton
                      v-if="effect.type === 'unlock-recipe'"
                      type="recipe"
                      :name="effect.recipe"
                      :size="36"
                      :clickable="true"
                      @click="handleIconClick('recipe', effect.recipe)"
                    />
                    <!-- Other effects - show generic effect icon or fallback -->
                    <div v-else :class="$style.effectIcon" :title="getEffectTooltip(effect)">
                      <SpriteIcon
                        v-if="getEffectIconKey(effect.type)"
                        :sprite-key="getEffectIconKey(effect.type)"
                        :title="getEffectTooltip(effect)"
                        :size="36"
                      />
                      <div v-else :class="$style.fallbackIcon" :title="getEffectTooltip(effect)">
                        {{ effect.type.charAt(0).toUpperCase() }}
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Research that depends on this technology -->
              <div v-if="dependentTechnologies.length > 0">
                <h4>Enables research:</h4>
                <div :class="$style.buttonGrid">
                  <div
                    v-for="depTech in dependentTechnologies"
                    :key="depTech"
                    :class="$style.gridItem"
                    @click="selectTechnology(depTech)"
                  >
                    <IconButton
                      type="technology"
                      :name="depTech"
                      :size="36"
                      :clickable="true"
                      @click="handleIconClick('technology', depTech)"
                    />
                  </div>
                </div>
              </div>
            </div>
          </template>

          <!-- Item-specific content -->
          <template v-if="selectedItem.types?.includes('item') && selectedItem.item">
            <!-- Crafting recipes -->
            <div v-if="selectedItem.craftingRecipes?.length > 0" :class="$style.recipeSection">
              <h5>Crafted by:</h5>
              <div :class="$style.recipeList">
                <div
                  v-for="recipeName in selectedItem.craftingRecipes"
                  :key="recipeName"
                  :class="$style.recipeReference"
                >
                  <IconButton
                    type="recipe"
                    :name="recipeName"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick('recipe', recipeName)"
                  />
                  <span>{{ getDisplayName(recipeName, 'recipe') }}</span>
                </div>
              </div>
            </div>

            <!-- Usage recipes -->
            <div v-if="selectedItem.usageRecipes?.length > 0" :class="$style.recipeSection">
              <h5>Used in:</h5>
              <div :class="$style.recipeList">
                <div
                  v-for="recipeName in selectedItem.usageRecipes"
                  :key="recipeName"
                  :class="$style.recipeReference"
                >
                  <IconButton
                    type="recipe"
                    :name="recipeName"
                    :size="36"
                    :clickable="true"
                    @click="handleIconClick('recipe', recipeName)"
                  />
                  <span>{{ getDisplayName(recipeName, 'recipe') }}</span>
                </div>
              </div>
            </div>
          </template>

          <!-- Fluid-specific content -->
          <template v-if="selectedItem.types?.includes('fluid') && selectedItem.fluid">
            <div :class="$style.fluidSection">
              <h4>Fluid Details</h4>
              <div v-if="selectedItem.fluid?.auto_barrel" :class="$style.fluidProperty">
                <strong>Auto-barrel:</strong> Yes
              </div>

              <!-- Crafting recipes -->
              <div v-if="selectedItem.craftingRecipes?.length > 0" :class="$style.recipeSection">
                <h5>Produced by:</h5>
                <div :class="$style.recipeList">
                  <div
                    v-for="recipeName in selectedItem.craftingRecipes"
                    :key="recipeName"
                    :class="$style.recipeReference"
                  >
                    <IconButton
                      type="recipe"
                      :name="recipeName"
                      :size="36"
                      :clickable="true"
                      @click="handleIconClick('recipe', recipeName)"
                    />
                    <span>{{ getDisplayName(recipeName, 'recipe') }}</span>
                  </div>
                </div>
              </div>

              <!-- Usage recipes -->
              <div v-if="selectedItem.usageRecipes?.length > 0" :class="$style.recipeSection">
                <h5>Used in:</h5>
                <div :class="$style.recipeList">
                  <div
                    v-for="recipeName in selectedItem.usageRecipes"
                    :key="recipeName"
                    :class="$style.recipeReference"
                  >
                    <IconButton
                      type="recipe"
                      :name="recipeName"
                      :size="36"
                      :clickable="true"
                      @click="handleIconClick('recipe', recipeName)"
                    />
                    <span>{{ getDisplayName(recipeName, 'recipe') }}</span>
                  </div>
                </div>
              </div>
            </div>
          </template>

          <!-- Tile-specific content -->
          <template v-if="selectedItem.types?.includes('tile') && selectedItem.tile">
            <!-- Game-style Tile Sections -->
            <div :class="$style.tileGameSections">
              <!-- Allows placement of -->
              <div :class="$style.tileGameSection" v-if="tilePlaceableItems.length > 0">
                <div :class="$style.tileSectionHeader">
                  <strong>Allows placement of</strong>
                </div>
                <div :class="$style.tileSectionContent">
                  <div :class="$style.tileSectionSlots">
                    <div
                      v-for="(item, index) in tilePlaceableItems.slice(0, 7)"
                      :key="index"
                      :class="$style.tileSlot"
                      :title="item.displayName"
                    >
                      <IconButton
                        :type="getPrimaryType(item)"
                        :name="item.name"
                        :size="28"
                        :clickable="true"
                        @click="handleIconClick('item', item.name)"
                      />
                    </div>
                    <div
                      v-for="n in Math.max(0, 7 - tilePlaceableItems.length)"
                      :key="`empty-${n}`"
                      :class="$style.tileSlot"
                    ></div>
                  </div>
                </div>
              </div>

              <!-- Source of -->
              <div :class="$style.tileGameSection" v-if="tileSourceFluid">
                <div :class="$style.tileSectionHeader">
                  <strong>Source of</strong>
                </div>
                <div :class="$style.tileSectionContent">
                  <div :class="$style.tileSectionSlots">
                    <div
                      v-if="tileSourceFluid"
                      :class="$style.tileSlot"
                      :title="tileSourceFluid.displayName"
                    >
                      <IconButton
                        type="fluid"
                        :name="tileSourceFluid.name"
                        :size="28"
                        :clickable="true"
                        @click="handleIconClick('fluid', tileSourceFluid.name)"
                      />
                    </div>
                    <div v-for="n in 6" :key="`empty-${n}`" :class="$style.tileSlot"></div>
                  </div>
                </div>
              </div>

              <!-- Extracted by -->
              <div :class="$style.tileGameSection" v-if="tileExtractor">
                <div :class="$style.tileSectionHeader">
                  <strong>Extracted by</strong>
                </div>
                <div :class="$style.tileSectionContent">
                  <div :class="$style.tileSectionSlots">
                    <div
                      v-if="tileExtractor"
                      :class="$style.tileSlot"
                      :title="tileExtractor.displayName"
                    >
                      <IconButton
                        type="entity"
                        :name="tileExtractor.name"
                        :size="28"
                        :clickable="true"
                        @click="handleIconClick('entity', tileExtractor.name)"
                      />
                    </div>
                    <div v-for="n in 6" :key="`empty-${n}`" :class="$style.tileSlot"></div>
                  </div>
                </div>
              </div>

              <!-- Can be placed on (for items like Landfill) -->
              <div :class="$style.tileGameSection" v-if="canBePlacedOnTiles.length > 0">
                <div :class="$style.tileSectionHeader">
                  <strong>Can be placed on</strong>
                </div>
                <div :class="$style.tileSectionContent">
                  <div :class="$style.tileSectionSlots">
                    <div
                      v-for="(tile, index) in canBePlacedOnTiles.slice(0, 7)"
                      :key="index"
                      :class="$style.tileSlot"
                      :title="tile.displayName"
                    >
                      <IconButton
                        type="tile"
                        :name="tile.name"
                        :size="28"
                        :clickable="true"
                        @click="handleIconClick('tile', tile.name)"
                      />
                    </div>
                    <div
                      v-for="n in Math.max(0, 7 - canBePlacedOnTiles.length)"
                      :key="`empty-${n}`"
                      :class="$style.tileSlot"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </template>

          <!-- Unlocked by -->
          <div v-if="unlockTechnologies.length > 0" :class="$style.recipeSection">
            <h4 title="Research required to unlock this item">
              {{ unlockTechnologies.length === 1 ? 'Unlocked by:' : 'Unlocked by any of:' }}
            </h4>
            <div :class="$style.unlockTechnologiesList">
              <div
                v-for="techName in unlockTechnologies"
                :key="techName"
                :class="$style.unlockTechnologyItem"
              >
                <div :class="$style.technologyIcon">
                  <IconButton
                    type="technology"
                    :name="techName"
                    :size="48"
                    :clickable="true"
                    @click="handleIconClick('technology', techName)"
                  />
                </div>
                <div :class="$style.technologyInfo">
                  <div :class="$style.technologyName">
                    {{ getDisplayName(techName, 'technology') }}
                  </div>
                  <div :class="$style.researchLevel">
                    Research level: {{ getTechnologyLevel(techName) }}
                  </div>
                  <div :class="$style.sciencePacks">
                    <IconButton
                      v-for="pack in getTechnologySciencePacks(techName)"
                      :key="pack.name"
                      type="recipe"
                      :name="pack.name"
                      :size="24"
                      :clickable="true"
                      @click="handleIconClick('recipe', pack.name)"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Raws Tab Content -->
      <div v-if="activeTab === 'raws'" :class="$style.rawsContent">
        <!-- Recipe Raw Data -->
        <div v-if="selectedItem?.recipe" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('recipe')">
            <span :class="$style.rawSectionTitle">Recipe Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.recipe ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.recipe" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(selectedItem.recipe, null, 2) }}</pre>
          </div>
        </div>

        <!-- Item Raw Data -->
        <div v-if="selectedItem?.item" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('item')">
            <span :class="$style.rawSectionTitle">Item Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.item ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.item" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(selectedItem.item, null, 2) }}</pre>
          </div>
        </div>

        <!-- Fluid Raw Data -->
        <div v-if="selectedItem?.fluid" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('fluid')">
            <span :class="$style.rawSectionTitle">Fluid Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.fluid ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.fluid" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(selectedItem.fluid, null, 2) }}</pre>
          </div>
        </div>

        <!-- Tile Raw Data -->
        <div v-if="selectedItem?.tile" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('tile')">
            <span :class="$style.rawSectionTitle">Tile Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.tile ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.tile" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(selectedItem.tile, null, 2) }}</pre>
          </div>
        </div>

        <!-- Technology Raw Data -->
        <div v-if="selectedItem?.technology" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('technology')">
            <span :class="$style.rawSectionTitle">Technology Data</span>
            <span :class="$style.rawSectionToggle">{{
              rawSectionsOpen.technology ? '▼' : '▶'
            }}</span>
          </button>
          <div v-if="rawSectionsOpen.technology" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{
              JSON.stringify(selectedItem.technology, null, 2)
            }}</pre>
          </div>
        </div>

        <!-- Entity Raw Data -->
        <div v-if="selectedItem?.entity" :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('entity')">
            <span :class="$style.rawSectionTitle">Entity Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.entity ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.entity" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(selectedItem.entity, null, 2) }}</pre>
          </div>
        </div>

        <!-- Unified Raw Data -->
        <div :class="$style.rawSection">
          <button :class="$style.rawSectionHeader" @click="toggleRawSection('unified')">
            <span :class="$style.rawSectionTitle">Unified Raw Data</span>
            <span :class="$style.rawSectionToggle">{{ rawSectionsOpen.unified ? '▼' : '▶' }}</span>
          </button>
          <div v-if="rawSectionsOpen.unified" :class="$style.rawSectionContent">
            <pre :class="$style.rawsData">{{ JSON.stringify(unifiedRawData, null, 2) }}</pre>
          </div>
        </div>
      </div>

      <!-- No Selection State -->
      <div v-if="!selectedItem" :class="$style.noSelection">
        <div :class="$style.noSelectionContent">
          <h3>Select an item to view details</h3>
          <p>
            Click on any item in the left panel to see its details, ingredients, and crafting
            requirements.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'

import {
  useFactorioData,
  useRecipeDetails,
  useItemDetails,
  useEntityDetails,
  usePowerDetails,
  useRecipeCrafting
} from '../../../src/index.js'

import SpriteIcon from './SpriteIcon.vue'
import IconButton from './IconButton.vue'
import FactorioSprite from './FactorioSprite.vue'
import { useStatistics } from '../../../src/composables/useStatistics.js'

// Use the data composable
const {
  recipesData,
  buildingsData,
  technologiesData,
  itemsData,
  fluidsData,
  tilesData,
  createUnifiedSelectionObject
} = useFactorioData()

// Tab state
const activeTab = ref('details')

// Raw sections state
const rawSectionsOpen = ref({
  recipe: false,
  item: false,
  fluid: false,
  tile: false,
  technology: false,
  entity: false,
  sprite: false,
  unified: false
})

// Toggle raw section
function toggleRawSection(section) {
  rawSectionsOpen.value[section] = !rawSectionsOpen.value[section]
}

// Helper function to get display name for any item
function getDisplayName(itemName, type) {
  if (!itemName || !type) return 'Unknown'

  // Try to get display name from unified object
  const unifiedObject = createUnifiedSelectionObject(type, itemName)
  return unifiedObject?.displayName || itemName
}

// Computed property for unified raw data (excluding already shown sections)
const unifiedRawData = computed(() => {
  if (!selectedItem.value) return null

  const {
    recipe: _recipe,
    item: _item,
    fluid: _fluid,
    tile: _tile,
    technology: _technology,
    entity: _entity,
    sprite: _sprite,
    ...unifiedProps
  } = selectedItem.value

  return unifiedProps
})

// Helper function to get primary type
function getPrimaryType(item) {
  if (!item || !item.types) return 'item'
  return item.types[0] || 'item'
}

// Props
const props = defineProps({
  name: {
    type: String,
    default: null
  },
  type: {
    type: String,
    default: null
  },
  isAnimationPaused: {
    type: Boolean,
    default: false
  }
})

// Emits
const emit = defineEmits(['select-item', 'toggle-animation-pause', 'item-selected'])

// Computed property to create selectedItem from name and type
const selectedItem = computed(() => {
  if (!props.name || !props.type) {
    return null
  }
  return createUnifiedSelectionObject(props.type, props.name)
})

// Use recipe details composable
const recipeDetails = useRecipeDetails(selectedItem, recipesData, buildingsData)
const {
  usedInRecipes,
  unlockTechnologies,
  madeInBuildings,
  getTechnologyLevel,
  getTechnologySciencePacks
} = recipeDetails

// Computed property for technologies that depend on the current technology
const dependentTechnologies = computed(() => {
  if (!selectedItem.value?.name || !technologiesData.value) return []

  const currentTechName = selectedItem.value.name
  const dependent = []

  for (const [techName, techData] of Object.entries(technologiesData.value)) {
    if (techData.prerequisites?.includes(currentTechName)) {
      dependent.push(techName)
    }
  }

  return dependent
})

// Use entity details composable
const entityDetails = useEntityDetails(selectedItem)
const { isEntity, itemTypeLabel, entitySpriteData } = entityDetails

// Use item details composable
const itemDetails = useItemDetails(selectedItem)
const { primaryResultStackSize, primaryResultTooltipDetails } = itemDetails

// Use power details composable
const powerDetails = usePowerDetails(selectedItem, isEntity)
const { hasPowerGeneration, powerOutput, hasElectricityConsumption } = powerDetails

// Use recipe crafting composable
const recipeCrafting = useRecipeCrafting(selectedItem, recipesData, isEntity)
const { canCraftRecipes } = recipeCrafting

// Computed properties for entity data
const entity = computed(() => selectedItem.value?.entity)
const item = computed(() => selectedItem.value?.item)
const _recipe = computed(() => selectedItem.value?.recipe)
const _technology = computed(() => selectedItem.value?.technology)
const _fluid = computed(() => selectedItem.value?.fluid)

// Computed properties for tile-specific data
const tilePlaceableItems = computed(() => {
  if (!selectedItem.value?.tile || !itemsData.value) return []

  const tileName = selectedItem.value.name
  const placeableItems = []

  // Find items that can be placed on this tile
  for (const [itemName, itemData] of Object.entries(itemsData.value)) {
    if (itemData.place_as_tile) {
      // Check if this item can be placed on the current tile
      const canPlace = checkTilePlacementCondition(itemData.place_as_tile, selectedItem.value.tile)
      if (canPlace) {
        placeableItems.push({
          name: itemData.place_as_tile?.result,
          displayName: itemData.displayName || itemName,
          types: ['item']
        })
      }
    }
  }

  return placeableItems
})

// Helper function to check if an item can be placed on a tile
function checkTilePlacementCondition(placeAsTile, targetTile) {
  if (!placeAsTile || !targetTile) return false
  const invert = placeAsTile.invert ?? false
  // Check tile_condition first (explicit whitelist)
  if (placeAsTile.tile_condition) {
    const allowedTiles = Array.isArray(placeAsTile.tile_condition)
      ? placeAsTile.tile_condition
      : [placeAsTile.tile_condition]

    if (allowedTiles.includes(targetTile.name) !== invert) {
      return true
    }
  }

  // Check collision mask condition
  if (placeAsTile.condition) {
    const targetCollisionMask = targetTile.collision_mask || {}
    let maskPasses = true

    // Handle both array and object formats for condition
    if (typeof placeAsTile.condition === 'object') {
      // Object format: { "water-tile": true, "ground-tile": true }
      for (const [layer, required] of Object.entries(placeAsTile.condition)) {
        const hasLayer = targetCollisionMask.layers?.[layer] || targetCollisionMask[layer]
        const shouldHaveLayer = placeAsTile.invert ? !required : required

        if (hasLayer !== shouldHaveLayer) {
          maskPasses = false
          break
        }
      }
    }

    if (!maskPasses) {
      return false
    }
  }

  return true
}

const tileSourceFluid = computed(() => {
  if (!selectedItem.value?.tile?.fluid || !fluidsData.value) return null

  const fluidName = selectedItem.value.tile.fluid
  const fluidData = fluidsData.value[fluidName]

  if (!fluidData) return null

  return {
    name: fluidName,
    displayName: fluidData.displayName || fluidName,
    types: ['fluid']
  }
})

const tileExtractor = computed(() => {
  // As mentioned, it's always offshore-pump for tiles with fluid
  if (!selectedItem.value?.tile?.fluid) return null

  return {
    name: 'offshore-pump',
    displayName: 'Offshore pump',
    types: ['entity']
  }
})

// Computed property for tiles that this item can be placed on (for items like Landfill)
const canBePlacedOnTiles = computed(() => {
  if (!selectedItem.value?.item?.place_as_tile || !tilesData.value) return []

  const placeAsTile = selectedItem.value.item.place_as_tile
  const compatibleTiles = []

  // Check all available tiles to see which ones this item can be placed on
  for (const [tileName, tileData] of Object.entries(tilesData.value)) {
    if (checkTilePlacementCondition(placeAsTile, tileData)) {
      compatibleTiles.push({
        name: tileName,
        displayName: tileData.displayName || tileName,
        types: ['tile']
      })
    }
  }

  return compatibleTiles
})

// Computed properties for entity-specific data
const entityPollution = computed(() => {
  if (!entity.value?.energy_source?.emissions_per_minute?.pollution) return null
  return entity.value.energy_source.emissions_per_minute.pollution
})

const entityAllowedEffects = computed(() => {
  if (!entity.value?.allowed_effects) return null
  return entity.value.allowed_effects
})

const entityEnergyUsage = computed(() => {
  if (!entity.value?.energy_usage || typeof entity.value.energy_usage !== 'string') return null

  // Parse energy usage string with Factorio energy mechanics
  // Min consumption is 3.33% (1/30th) of the energy usage
  // Max consumption is energy usage + min consumption
  const match = entity.value.energy_usage.match(/(\d+(?:\.\d+)?)/)
  if (!match) return null

  const baseConsumption = parseFloat(match[1])
  const minConsumption = baseConsumption / 30 // 3.33% of energy usage
  const maxConsumption = baseConsumption + minConsumption

  return {
    min: minConsumption,
    max: maxConsumption
  }
})

// Statistics data structure
const { statisticsData } = useStatistics(selectedItem)

// Event handlers
function handleIconClick(type, name, data = null) {
  emit('select-item', type, name, data)
}

// Convenience functions for backward compatibility
function selectTechnology(technologyName) {
  emit('select-item', 'technology', technologyName)
}

// Helper function to get icon key for effect types
function getEffectIconKey(effectType) {
  const iconMap = {
    'ammo-damage': 'utility-damage',
    'gun-speed': 'utility-speed',
    'turret-attack': 'utility-attack',
    'unlock-recipe': 'utility-unlock',
    'bulk-inserter-capacity-bonus': 'utility-inserter',
    'train-braking-force-bonus': 'utility-train',
    'maximum-following-robots-count': 'utility-robot',
    'laboratory-speed': 'utility-lab',
    'worker-robot-speed': 'utility-robot',
    'character-inventory-slots-bonus': 'utility-inventory',
    'character-logistic-trash-slots': 'utility-logistics',
    'worker-robot-storage': 'utility-robot',
    'inserter-stack-size-bonus': 'utility-inserter',
    'mining-drill-productivity-bonus': 'utility-mining',
    'artillery-range': 'utility-artillery'
  }
  return iconMap[effectType] || null
}

// Helper function to generate effect tooltip text
function getEffectTooltip(effect) {
  const { type, modifier, ammo_category, turret_id, recipe } = effect

  switch (type) {
    case 'unlock-recipe':
      return `Unlocks recipe: ${getDisplayName(recipe, 'recipe')}`

    case 'ammo-damage': {
      const damagePercent = Math.round(modifier * 100)
      return `+${damagePercent}% ${ammo_category || 'ammo'} damage`
    }

    case 'gun-speed': {
      const speedPercent = Math.round(modifier * 100)
      return `+${speedPercent}% ${ammo_category || 'ammo'} firing speed`
    }

    case 'turret-attack': {
      const attackPercent = Math.round(modifier * 100)
      return `+${attackPercent}% ${turret_id || 'turret'} attack power`
    }

    case 'bulk-inserter-capacity-bonus':
      return `+${modifier} bulk inserter capacity`

    case 'train-braking-force-bonus': {
      const brakingPercent = Math.round(modifier * 100)
      return `+${brakingPercent}% train braking force`
    }

    case 'maximum-following-robots-count':
      return `+${modifier} follower robots`

    case 'laboratory-speed': {
      const labSpeedPercent = Math.round(modifier * 100)
      return `+${labSpeedPercent}% research speed`
    }

    case 'worker-robot-speed': {
      const robotSpeedPercent = Math.round(modifier * 100)
      return `+${robotSpeedPercent}% robot speed`
    }

    case 'character-inventory-slots-bonus':
      return `+${modifier} inventory slots`

    case 'character-logistic-trash-slots':
      return `+${modifier} logistic trash slots`

    case 'worker-robot-storage':
      return `+${modifier} robot cargo slots`

    case 'inserter-stack-size-bonus':
      return `+${modifier} inserter stack size`

    case 'mining-drill-productivity-bonus': {
      const miningPercent = Math.round(modifier * 100)
      return `+${miningPercent}% mining productivity`
    }

    case 'artillery-range': {
      const artilleryPercent = Math.round(modifier * 100)
      return `+${artilleryPercent}% artillery range`
    }

    // Boolean effects
    case 'cliff-deconstruction-enabled':
      return 'Enables cliff destruction'

    case 'create-ghost-on-entity-death':
      return 'Creates blueprints on entity death'

    case 'character-logistic-requests':
      return 'Enables logistic requests'

    case 'vehicle-logistics':
      return 'Enables vehicle logistics'

    case 'mining-with-fluid':
      return 'Enables fluid-based mining'

    case 'unlock-circuit-network':
      return 'Unlocks circuit network'

    case 'rail-planner-allow-elevated-rails':
      return 'Enables elevated rails'

    default:
      // Generic fallback for unknown effects
      if (modifier !== undefined) {
        if (typeof modifier === 'boolean') {
          return modifier ? `Enables ${type}` : `Disables ${type}`
        }
        return `${type}: ${modifier}`
      }
      return type
  }
}
</script>

<style module>
.detailsPane {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: var(--vp-c-bg);
  border-left: 1px solid var(--vp-c-border);
  overflow-y: auto;
}

.itemDetails {
  padding: 12px;
  max-width: 100%;
}

.itemHeader {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding: 6px 10px;
  background: linear-gradient(135deg, #8b7355, #6b5b47);
  border-radius: 2px;
  border: 1px solid #9d8563;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.3);
  gap: 16px;
}

.headerTitle {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
}

.headerTabs {
  display: flex;
  gap: 2px;
}

.headerTabs button {
  background: #4a4a4a;
  border: 1px solid #6a6a6a;
  border-top: 1px solid #7a7a7a;
  border-left: 1px solid #7a7a7a;
  border-radius: 2px;
  padding: 4px 8px;
  color: #ffffff;
  font-size: 12px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow:
    1px 1px 0px rgba(0, 0, 0, 0.3),
    inset 0 1px 1px rgba(255, 255, 255, 0.1);
}

.headerTabs button:hover {
  background: #5a5a5a;
  border-color: #7a7a7a;
  border-top: 1px solid #8a8a8a;
  border-left: 1px solid #8a8a8a;
  box-shadow:
    1px 1px 0px rgba(0, 0, 0, 0.4),
    inset 0 1px 1px rgba(255, 255, 255, 0.15);
}

.headerTabs button.active {
  background: #6a6a6a;
  border-color: #8a8a8a;
  border-top: 1px solid #9a9a9a;
  border-left: 1px solid #9a9a9a;
  box-shadow:
    1px 1px 0px rgba(0, 0, 0, 0.5),
    inset 0 1px 1px rgba(255, 255, 255, 0.2);
  color: #ffffff;
}

.itemHeader h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
  color: #000000;
}

.headerControls {
  display: flex;
  gap: 8px;
}

.controlButton {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  background: none;
  border: none;
  border-radius: 2px;
  color: #000000;
  cursor: pointer;
  transition: background 0.2s ease;
}

.controlButton:hover {
  background: rgba(0, 0, 0, 0.1);
}

.itemImageContainer {
  width: 100%;
  margin-bottom: 20px;
  background: #2d2d2d;
  border-radius: 4px;
  border: 1px solid #4a4a4a;
  display: flex;
  justify-content: center;
  align-items: center;
  box-sizing: border-box;
  padding: 0;
  margin: 0;
  /* Maintain 698x265 aspect ratio (265/698 ≈ 0.3797) */
  aspect-ratio: 698 / 265;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.usageDescription {
  margin-bottom: 20px;
  padding: 15px;
  background: #3a3a3a;
  border-radius: 2px;
}

.usageDescription p {
  margin: 0;
  color: #ffffff;
  line-height: 1.6;
  font-size: 14px;
}

.stackSizeDisplay {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
  color: #ffffff;
  font-size: 14px;
}

.stackSizeIcon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  background: #4a4a4a;
  border-radius: 50%;
  color: #ffffff;
  font-size: 12px;
  font-weight: bold;
  border: 1px solid #5a5a5a;
}

.statistics {
  margin-bottom: 12px;
  padding: 10px;
  background: linear-gradient(135deg, #3a3a3a, #2d2d2d);
  border-radius: 2px;
  border: 1px solid #4a4a4a;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.statItem {
  margin-bottom: 6px;
  color: #ffffff;
  font-size: 13px;
  line-height: 1.3;
}

.statItem:last-child {
  margin-bottom: 0;
}

.statItem strong {
  color: #ffffff;
  font-weight: 600;
}

.resistanceList {
  margin: 4px 0 0 0;
  padding-left: 16px;
  color: #ffffff;
  font-size: 14px;
  list-style-type: square;
}

.resistanceList li {
  margin-bottom: 2px;
}

/* Second level children - also square bullets */
.resistanceList .resistanceList {
  list-style-type: square;
}

.powerGeneration {
  margin-bottom: 20px;
  padding: 12px;
  background: #3a3a3a;
  border-radius: 2px;
}

.powerSection {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #ffffff;
  font-size: 14px;
  margin-bottom: 8px;
}

.powerOutput {
  color: #ffffff;
  font-size: 14px;
}

.powerOutput strong {
  color: #ffffff;
}

.modInfo {
  margin-bottom: 12px;
  padding: 6px 10px;
  background: #3a3a3a;
  border-radius: 2px;
  font-size: 12px;
  color: #87ceeb;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.modOrigin {
  color: #87ceeb;
  font-size: 12px;
  line-height: 1.2;
}

.electricityConsumption {
  margin-bottom: 12px;
  padding: 10px;
  background: #3a3a3a;
  border-radius: 2px;
  border: 1px solid #4a4a4a;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
}

.electricitySection {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #ffeb3b; /* Vibrant electricity yellow color */
  font-size: 13px;
  margin-bottom: 8px;
}

.electricitySection .sprite-icon {
  filter: hue-rotate(45deg) saturate(2) brightness(1.2) !important; /* Convert to electricity yellow */
}

/* Alternative approach - target the background image directly */
.electricitySection .sprite-icon[style*='background-image'] {
  filter: hue-rotate(45deg) saturate(2) brightness(1.2) !important; /* Convert to electricity yellow */
}

/* Most specific approach - target the electricity icon class */
.electricity-icon {
  filter: hue-rotate(45deg) saturate(2) brightness(1.2) !important; /* Convert to electricity yellow */
}

.energyDetails {
  margin-top: 8px;
}

.energyItem {
  color: #ffffff;
  font-size: 13px;
  margin-bottom: 4px;
}

.energyItem strong {
  color: #ffffff;
  font-weight: 600;
}

.itemContent {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.recipeSection,
.technologySection {
  padding: 10px;
  background: linear-gradient(135deg, #3a3a3a, #2d2d2d);
  border-radius: 2px;
  border: 1px solid #4a4a4a;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
  margin-bottom: 10px;
}

.recipeSection h4,
.technologySection h4 {
  margin: 0 0 8px 0;
  font-size: 13px;
  font-weight: bold;
  color: #ffffff;
  display: flex;
  align-items: center;
  gap: 6px;
}

.technologySection h5 {
  margin: 0 0 8px 0;
  font-size: 13px;
  font-weight: bold;
  color: #ffffff;
}

/* Technology-specific styles */
.researchCost {
  margin-bottom: 15px;
  padding: 10px;
  background: #2a2a2a;
  border-radius: 2px;
  border: 1px solid #4a4a4a;
}

.researchTrigger {
  margin-bottom: 15px;
  padding: 10px;
  background: #2a2a2a;
  border-radius: 2px;
  border: 1px solid #4a4a4a;
}

.triggerDetails {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.triggerItem {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #ffffff;
  font-size: 13px;
}

.costDetails {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.costItem {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #ffffff;
  font-size: 13px;
}

.sciencePacksSection {
  margin-top: 8px;
}

.sciencePacksList {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-top: 6px;
}

.sciencePackItem {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 6px;
  background: #3a3a3a;
  border-radius: 2px;
  color: #ffffff;
  font-size: 12px;
}

.researchTimeSection {
  margin-top: 12px;
}

.researchTimeItem {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #ffffff;
  font-size: 13px;
  margin-bottom: 4px;
}

.researchTimeItem strong {
  min-width: 120px;
  display: inline-block;
}

.researchCountItem {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #ffffff;
  font-size: 13px;
  padding-left: 22px; /* Account for icon width + gap in research time line */
}

.researchCountItem strong {
  min-width: 120px;
  display: inline-block;
}

/* Effect display styles */
.effectIcon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
}

.fallbackIcon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: #4a4a4a;
  border-radius: 2px;
  color: #ffffff;
  font-size: 16px;
  font-weight: bold;
  border: 1px solid #5a5a5a;
}

.technologyLevel {
  margin-bottom: 15px;
  padding: 10px;
  background: #2a2a2a;
  border-radius: 2px;
  border: 1px solid #4a4a4a;
}

.levelInfo {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.levelItem {
  color: #ffffff;
  font-size: 13px;
}

.ingredientsList {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 8px;
}

.ingredientList,
.resultList,
.buildingList,
.usedInList,
.used-in-recipes,
.prerequisiteList,
.effectList {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.ingredientItem,
.productItem,
.buildingItem,
.itemReference,
.prerequisiteItem,
.effectItem {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 3px 6px;
  background: #4a4a4a;
  border-radius: 2px;
  cursor: pointer;
  transition: background 0.2s ease;
  color: #ffffff;
  font-size: 13px;
  margin-bottom: 3px;
  min-height: 36px;
}

.ingredientItem:hover,
.productItem:hover,
.buildingItem:hover,
.itemReference:hover,
.prerequisiteItem:hover {
  background: #5a5a5a;
}

.craftingTimeContainer {
  margin-top: 8px;
}

.craftingTimeHr {
  border: none;
  height: 1px;
  background: #5a5a5a;
  margin: 8px 0;
}

.craftingTime {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #ffffff;
  font-size: 13px;
  padding: 4px 0;
  margin-left: 40px; /* Align with ingredient quantities */
}

.researchItem {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px;
  background: #4a4a4a;
  border-radius: 2px;
  color: #ffffff;
  font-size: 14px;
}

.noSelection {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  color: #888888;
}

.noSelection-content {
  text-align: center;
}

.noSelection-content h3 {
  margin: 0 0 8px 0;
  color: #ffffff;
  font-size: 18px;
}

.noSelection-content p {
  margin: 0;
  line-height: 1.6;
  font-size: 14px;
}

/* Dark mode adjustments */
.dark .controlButton {
  background: var(--vp-c-bg-soft);
  border-color: var(--vp-c-border);
}

.dark .controlButton:hover {
  background: var(--vp-c-bg-soft-hover);
}

/* New section styles */
.itemSection,
.fluidSection,
.tileSection {
  padding: 15px;
  background: #3a3a3a;
  border-radius: 2px;
  border: 1px solid #4a4a4a;
}

.itemSection h4,
.fluidSection h4,
.tileSection h4 {
  margin: 0 0 15px 0;
  font-size: 14px;
  font-weight: bold;
  color: #ffffff;
}

.itemProperty,
.fluidProperty,
.tileProperty {
  margin-bottom: 8px;
  color: #ffffff;
  font-size: 14px;
}

/* Game-style Tile UI */
.tileImageContainer {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 20px;
  padding: 20px;
  background: #2a2a2a;
  border-radius: 4px;
  border: 1px solid #4a4a4a;
}

.tileGameSections {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.tileGameSection {
  background: #3a3a3a;
  border-radius: 4px;
  border: 1px solid #4a4a4a;
  padding: 12px;
}

.tileSectionHeader {
  margin-bottom: 8px;
  color: #ffffff;
  font-size: 14px;
  font-weight: bold;
}

.tileSectionContent {
  display: flex;
  align-items: center;
  gap: 8px;
}

.tileSectionIcon {
  flex-shrink: 0;
}

.tileSectionSlots {
  display: flex;
  gap: 2px;
  flex: 1;
}

.tileSlot {
  width: 32px;
  height: 32px;
  background: #4a4a4a;
  border: 1px solid #5a5a5a;
  border-radius: 2px;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
}

.emptyIcon {
  width: 32px;
  height: 32px;
  background: #4a4a4a;
  border: 1px solid #5a5a5a;
  border-radius: 2px;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.3);
}

.recipeList {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.recipeReference {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px;
  background: #4a4a4a;
  border-radius: 2px;
  cursor: pointer;
  transition: background 0.2s ease;
  color: #ffffff;
  font-size: 14px;
}

.recipeReference:hover {
  background: #5a5a5a;
}

/* Made in Grid Styles */
.madeInGrid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: 36px;
  gap: 1px;
  max-height: 200px;
  overflow-y: auto;
  overflow-x: hidden;
  background: #2a2a2a;
  border: 1px solid #4a4a4a;
  border-radius: 2px;
  padding: 1px;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.madeInItem {
  width: 36px;
  height: 36px;
  background: #4a4a4a;
  border: 1px solid #5a5a5a;
  border-radius: 1px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  overflow: hidden;
}

.madeInItem :deep(.icon-button) {
  border: none !important;
  background: transparent !important;
  border-radius: 0 !important;
}

.madeInItem:hover {
  background: #5a5a5a;
  border-color: #6a6a6a;
}

/* Button Grid Styles */
.buttonGrid {
  display: grid;
  grid-template-columns: repeat(13, 1fr);
  grid-auto-rows: 36px;
  gap: 1px;
  max-height: 200px;
  overflow-y: auto;
  overflow-x: hidden;
  background: #2a2a2a;
  border: 1px solid #4a4a4a;
  border-radius: 2px;
  padding: 1px;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.gridItem {
  width: 36px;
  height: 36px;
  background: #4a4a4a;
  border: 1px solid #5a5a5a;
  border-radius: 1px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  overflow: hidden;
}

.gridItem :deep(.icon-button) {
  border: none !important;
  background: transparent !important;
  border-radius: 0 !important;
}

.gridItem:hover {
  background: #5a5a5a;
  border-color: #6a6a6a;
}

/* Can Craft Grid Styles */
.canCraftGrid {
  display: grid;
  grid-template-columns: repeat(13, 1fr);
  grid-auto-rows: 36px;
  gap: 1px;
  max-height: 200px;
  overflow-y: auto;
  overflow-x: hidden;
  background: #2a2a2a;
  border: 1px solid #4a4a4a;
  border-radius: 2px;
  padding: 1px;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3);
}

.canCraftItem {
  width: 36px;
  height: 36px;
  background: #4a4a4a;
  border: 1px solid #5a5a5a;
  border-radius: 1px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  overflow: hidden;
}

.canCraftItem :deep(.icon-button) {
  border: none !important;
  background: transparent !important;
  border-radius: 0 !important;
}

.canCraftItem:hover {
  background: #5a5a5a;
  border-color: #6a6a6a;
}

/* Unlock Technologies Styles */
.unlockTechnologiesList {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.unlockTechnologyItem {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  background: #4a4a4a;
  border-radius: 2px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.unlockTechnologyItem:hover {
  background: #5a5a5a;
}

.technologyIcon {
  flex-shrink: 0;
}

.technologyInfo {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.technologyName {
  font-size: 14px;
  font-weight: bold;
  color: #ffffff;
}

.researchLevel {
  font-size: 12px;
  color: #cccccc;
}

.sciencePacks {
  display: flex;
  gap: 4px;
  flex-wrap: wrap;
}

.sciencePack {
  font-size: 11px;
  color: #87ceeb;
  background: rgba(135, 206, 235, 0.1);
  padding: 2px 6px;
  border-radius: 2px;
  border: 1px solid rgba(135, 206, 235, 0.3);
}

/* Raws Content Styles */
.rawsContent {
  padding: 1rem 0;
}

.rawSection {
  margin-bottom: 12px;
  border: 1px solid #4a4a4a;
  border-radius: 4px;
  background: #3a3a3a;
  overflow: hidden;
}

.rawSectionHeader {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(135deg, #4a4a4a, #3a3a3a);
  border: none;
  color: #ffffff;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s ease;
  border-bottom: 1px solid #5a5a5a;
}

.rawSectionHeader:hover {
  background: linear-gradient(135deg, #5a5a5a, #4a4a4a);
}

.rawSectionTitle {
  flex: 1;
  text-align: left;
}

.rawSectionToggle {
  font-size: 12px;
  color: #cccccc;
  transition: transform 0.2s ease;
}

.rawSectionContent {
  padding: 0;
  background: #2d2d2d;
}

.rawsData {
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  border-radius: 0;
  padding: 1rem;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 0.875rem;
  line-height: 1.5;
  overflow-x: auto;
  white-space: pre-wrap;
  word-break: break-word;
  max-height: 40vh;
  overflow-y: auto;
  margin: 0;
}
</style>
