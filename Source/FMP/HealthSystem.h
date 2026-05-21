// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Components/ActorComponent.h"
#include "HealthSystem.generated.h"

class UHealthSystem;

/**
 * @brief Broadcast when a health component changes its current health.
 *
 * @param HealthComponent Component whose value changed.
 * @param CurrentHealth New clamped health value.
 * @param MaxHealth Maximum health used for clamping.
 * @param Delta Signed difference between the new and previous health values.
 *
 * @ingroup FMPGameplay
 */
DECLARE_DYNAMIC_MULTICAST_DELEGATE_FourParams(FOnHealthChangedSignature, UHealthSystem*, HealthComponent, float, CurrentHealth, float, MaxHealth, float, Delta);

/**
 * @brief Broadcast once when health reaches zero from a living state.
 *
 * @param HealthComponent Component that entered the dead state.
 *
 * @ingroup FMPGameplay
 */
DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FOnDeathSignature, UHealthSystem*, HealthComponent);

/**
 * @brief Actor component that owns simple clamped health state and Blueprint death notifications.
 *
 * UHealthSystem initializes to full health, clamps configured values during BeginPlay, and
 * exposes Blueprint-callable helpers for applying positive healing or damage amounts. Once the
 * component reaches zero health it marks both death flags and ignores further AddHealth or
 * RemoveHealth calls; direct SetHealth calls remain clamped but only broadcast when the stored
 * value changes.
 *
 * @note This component does not replicate health or death state by itself.
 * @note All public mutation methods are expected to be called on the game thread.
 * @see FOnHealthChangedSignature
 * @see FOnDeathSignature
 *
 * @ingroup FMPGameplay
 */
UCLASS( ClassGroup=(Custom), meta=(BlueprintSpawnableComponent) )
class FMP_API UHealthSystem : public UActorComponent
{
	GENERATED_BODY()

public:	
	/** @brief Creates the component with ticking disabled and default health set to 100. */
	UHealthSystem();

protected:
	/** @brief Clamps configured health values and emits the initial health update after play begins. */
	virtual void BeginPlay() override;

	/** @brief Current clamped health value exposed to Blueprints for read-only status display. */
	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "Health", meta = (ClampMin = "0.0"))
	float CurrentHealth;

	/** @brief Maximum health used to clamp CurrentHealth and SetHealth input values. */
	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "Health", meta = (ClampMin = "0.0"))
	float MaxHealth;

	/** @brief True after CurrentHealth reaches zero. */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Health")
	bool bIsDead;

	/** @brief Mirrors bIsDead for Blueprint logic that distinguishes player death state. */
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Health")
	bool bIsPlayerDead;

	/**
	 * @brief Updates cached death state and broadcasts health/death delegates.
	 *
	 * @param PreviousHealth Health value before the current mutation.
	 */
	void HandleHealthUpdated(float PreviousHealth);

public:	
	/** @brief Blueprint event fired whenever CurrentHealth changes after clamping. */
	UPROPERTY(BlueprintAssignable, Category = "Health")
	FOnHealthChangedSignature OnHealthChanged;

	/** @brief Blueprint event fired once when the component first reaches zero health. */
	UPROPERTY(BlueprintAssignable, Category = "Health")
	FOnDeathSignature OnDeath;

	/**
	 * @brief Increases health by a positive amount while alive.
	 *
	 * @param Amount Positive amount to add before clamping to MaxHealth.
	 * @note Non-positive values and calls made after death are ignored.
	 */
	UFUNCTION(BlueprintCallable, Category = "Health")
	void AddHealth(float Amount);

	/**
	 * @brief Decreases health by a positive amount while alive.
	 *
	 * @param Amount Positive amount to subtract before clamping to zero.
	 * @note Non-positive values and calls made after death are ignored.
	 */
	UFUNCTION(BlueprintCallable, Category = "Health")
	void RemoveHealth(float Amount);

	/**
	 * @brief Sets health directly and broadcasts if the clamped value changes.
	 *
	 * @param NewHealth Desired health value, clamped to the inclusive range [0, MaxHealth].
	 */
	UFUNCTION(BlueprintCallable, Category = "Health")
	void SetHealth(float NewHealth);

	/** @return Current clamped health value. */
	UFUNCTION(BlueprintPure, Category = "Health")
	float GetHealth() const;

	/** @return Maximum health used by this component. */
	UFUNCTION(BlueprintPure, Category = "Health")
	float GetMaxHealth() const;

	/** @return True when CurrentHealth is zero. */
	UFUNCTION(BlueprintPure, Category = "Health")
	bool IsDead() const;

	/** @return Current player death flag, which mirrors IsDead in this implementation. */
	UFUNCTION(BlueprintPure, Category = "Health")
	bool IsPlayerDead() const;
};
